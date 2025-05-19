import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VendorAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerNewUser(
      String email, String fullName, String password) async {
    String res = 'something went wrong';

    try {
      //Create user, first in auth then in cloud store
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      //Create collection buyers. Its contain all registered users
      await _firestore.collection('vendors').doc(userCredential.user!.uid).set({
        //Pass data
        'fullname': fullName,
        'storeImage': "", //leave it empty
        'email': email,
        'uid': userCredential.user!.uid,
        'pincode': "",
        'locality': '',
        'city': '',
        'state': '',
      });

      _auth.signOut();

      res = 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //Login user
  Future<String> loginUser(String email, String password) async {
    String res = 'something went wrong';
    try {
      //Email vendors koleksiyonunda var mı kontrol et (mail unique olacağı için tel döküman gelmesi yeterli)
      QuerySnapshot vendorQuery = await _firestore
          .collection('vendors')
          .where('email', isEqualTo: email)
          .get();

      if (vendorQuery.docs.isEmpty) {
        return 'This email is not registered as a vendor.';
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      res = 'vendor_success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        res = 'Wrong password provided for that user.';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> resetPassword(String email) async {
    String res = 'something went wrong';

    try {
      await _auth.sendPasswordResetEmail(email: email);
      res = 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        res = 'Please enter a valid email address.';
      } else {
        res = e.message ?? 'An error occurred while resetting password.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
