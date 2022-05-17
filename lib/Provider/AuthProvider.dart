import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../src/LoginState.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

        // _guestBookSubscription = FirebaseFirestore.insta // FirebaseFirestore.instance
    //     //     .collection('attendees')
    //     //     .where('attending', isEqualTo: true)
    //     //     .snapshots()
    //     //     .listen((snapshot) {
    //     //   _attendees = snapshot.docs.length;
    //     //   notifyListeners();
    //     // });
    //     //
    //     // FirebaseAuth.instance.userChanges().listen((user) {
    //     //   if (user != null) {
    //     //     _loginState = ApplicationLoginState.loggedIn;nce
        //     .collection('guestbook')
        //     .orderBy('timestamp', descending: true)
        //     .snapshots()
        //     .listen((snapshot) {
        //   _guestBookMessages = [];
        //   for (final document in snapshot.docs) {
        //     _guestBookMessages.add(
        //       GuestBookMessage(
        //         name: document.data()['name'] as String,
        //         message: document.data()['text'] as String,
        //       ),
        //     );
        //   }
        //   notifyListeners();
        // });
        // _attendingSubscription = FirebaseFirestore.instance
        //     .collection('attendees')
        //     .doc(user.uid)
        //     .snapshots()
        //     .listen((snapshot) {
        //   if (snapshot.data() != null) {
        //     if (snapshot.data()!['attending'] as bool) {
        //       _attending = Attending.yes;
        //     } else {
        //       _attending = Attending.no;
        //     }
        //   } else {
        //     _attending = Attending.unknown;
        //   }
        //   notifyListeners();
        // });
  //     } else {
  //       _loginState = ApplicationLoginState.loggedOut;
  //       // _guestBookMessages = [];
  //       // _guestBookSubscription?.cancel();
  //       // _attendingSubscription?.cancel();
  //     }
  //     notifyListeners();
  //   });
  // }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;
  bool? _checkUser;
  String? _email;
  String? get email => _email;

  // StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  // List<GuestBookMessage> _guestBookMessages = [];
  // List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  int _attendees = 0;
  int get attendees => _attendees;

  // Attending _attending = Attending.unknown;
  // StreamSubscription<DocumentSnapshot>? _attendingSubscription;
  // Attending get attending => _attending;
  // set attending(Attending attending) {
  //   final userDoc = FirebaseFirestore.instance
  //       .collection('attendees')
  //       .doc();
  //   if (attending == Attending.yes) {
  //     userDoc.set(<String, dynamic>{'attending': true});
  //   } else {
  //     userDoc.set(<String, dynamic>{'attending': false});
  //   }
  // }


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
      _email = email;
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
  }



  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }



}