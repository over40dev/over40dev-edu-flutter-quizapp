import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Future<FirebaseUser> get getUser => _auth.currentUser();
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      AuthResult res = await _auth.signInWithCredential(credential);
      updateUserData(res.user);

      return res.user;
    } catch (e) {
      print(e); // TODO: show dialog
      return null;
    }
  }

  Future<FirebaseUser> anonLogin() async {
    AuthResult res = await _auth.signInAnonymously();
    updateUserData(res.user);
    return res.user;
  }

  Future<void> updateUserData(FirebaseUser user) {
    DocumentReference reportRef = _db.collection('reports').document(user.uid);

    return reportRef.setData({
      'uid': user.uid,
      'lastActivity': DateTime.now(),
    }, merge: true);
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
