import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  String _defaultImage = '';

  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  //My profile

  bool? _checkUser;
  StreamSubscription<DocumentSnapshot>? _profileSubscription;
  StreamSubscription<QuerySnapshot>? ItemSubscription;
  StreamSubscription<QuerySnapshot>? _userSubscription;

  Future<bool?> verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _checkUser = true;
      } else {
        _checkUser = false;
      }

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
    return _checkUser;
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
    notifyListeners();
  }

  Future<void> registerAccount(
      String email,
      String id,
      String password,
      String name,
      String profession,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(id);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(<String, dynamic>{
      'image':
          "https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206",
      'email': email,
      'name': name,
      'id': id,
      'profession': profession,
      'password': password,
      'subscriber': [],
      'subscribing': [],
      'bookmark': [],
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
