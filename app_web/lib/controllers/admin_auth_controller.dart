import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Login user
  Future<String> loginUser(String email, String password) async {
    String res = 'something went wrong';
    try {
      //Email vendors koleksiyonunda var mı kontrol et (mail unique olacağı için tel döküman gelmesi yeterli)
      QuerySnapshot vendorQuery =
          await _firestore
              .collection('admins')
              .where('email', isEqualTo: email)
              .get();

      if (vendorQuery.docs.isEmpty) {
        return 'This email is not registered as a admin.';
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      res = 'admin_success';
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

enum FirebaseCollections { buyers, vendors, admins }
