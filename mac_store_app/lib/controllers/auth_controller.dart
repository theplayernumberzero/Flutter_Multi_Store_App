import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
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
      await _firestore.collection('buyers').doc(userCredential.user!.uid).set({
        //Pass data
        'fullname': fullName,
        'profileImage': "", //leave it empty
        'email': email,
        'uid': userCredential.user!.uid,
        'pincode': "",
        'locality': '',
        'city': '',
        'state': '',
      });

      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //Login user
  Future<String> loginUser(String email, String password) async {
    String res = 'something went wrong';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "Success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
