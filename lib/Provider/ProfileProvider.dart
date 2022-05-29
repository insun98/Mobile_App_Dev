import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../firebase_options.dart';


class ProfileProvider extends ChangeNotifier {

  String _defaultImage='';
  ProfileProvider() {
    init();
  }


  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    //Default image for profile
    final storageRef = FirebaseStorage.instance.ref();
    final filename = "defaultProfile.png";
    final  defaultProPicRef = storageRef.child(filename);
    final downloadUrl = await defaultProPicRef.getDownloadURL();
    _defaultImage = downloadUrl;

    //My Profile
    FirebaseAuth.instance.userChanges().listen((user) {
      _profileSubscription = FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.data() != null) {
          _myProfile.name = snapshot.data()!['name'];
          _myProfile.id = snapshot.data()!['id'];
          _myProfile.email = snapshot.data()!['email'];
          _myProfile.subscribers = snapshot.data()!['subscribers'];
          _myProfile.subscribing = snapshot.data()!['subscribing'];
          _myProfile.bookmark = snapshot.data()!['bookmark'];
          _myProfile.photo = snapshot.data()!['image'];
          _myProfile.uid = snapshot.data()!['uid'];
          _myProfile.profession = snapshot.data()!['profession'];
          notifyListeners();
        }
      });


      //All users
      _allUserSubscription = FirebaseFirestore.instance
          .collection('user')
          .snapshots()
          .listen((snapshot) {
        _allUsers = [];
        for (final document in snapshot.docs) {
          _allUsers.add(
            Profile(
              name: document.data()['name'],
              id: document.data()['id'],
              profession: document.data()['profession'],
                email: document.data()['email'],
                subscribers: document.data()['subscribers'],
                subscribing: document.data()['subscribing'],
                bookmark: document.data()['bookmark'],
                photo: document.data()['photo'],
                uid: document.data()['uid'],
            ),
          );
        }
        notifyListeners();
      });


});
        }
        Future<void> getUser(String uid) async {
          FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .snapshots()
              .listen((snapshot) {
            if (snapshot.data() != null) {
              _otherProfile.name = snapshot.data()!['name'];
              _otherProfile.email = snapshot.data()!['email'];
              _otherProfile.id = snapshot.data()!['id'];
              _otherProfile.subscribers = snapshot.data()!['subscribers'];
              _otherProfile.subscribing = snapshot.data()!['subscribing'];
              _otherProfile.bookmark = snapshot.data()!['bookmark'];
              _otherProfile.photo = snapshot.data()!['image'];
              _otherProfile.uid = snapshot.data()!['uid'];
              _otherProfile.profession = snapshot.data()!['uid'];
              notifyListeners();
            }
          });

          for(var post in _otherProfile.bookmark){
            FirebaseFirestore.instance
                .collection('post')
                .doc(post)
                .snapshots()
                .listen((snapshot) {

            bookMarkPost.add(Post(

            ));
          }
        }
// Future<void> set() async {
//   FirebaseFirestore.instance
//       .collection('user')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .snapshots()
//       .listen((snapshot) {
//     if (snapshot.data() != null) {
//       _profile.name = snapshot.data()!['name'];
//       _profile.email = snapshot.data()!['email'];
//       _profile.id = snapshot.data()!['id'];
//       _profile.subscribers = snapshot.data()!['subscribers'];
//       _profile.bookmark = snapshot.data()!['bookmark'];
//       _profile.photo = snapshot.data()!['image'];
//       _profile.uid = snapshot.data()!['uid'];
//       notifyListeners();
//     }
//   });
// }
  bool? _checkUser;
  List<Profile> _subscribersProfile = [];
  List<Profile> get subscribersProfile => _subscribersProfile;
  List<Profile> _allUsers= [];
  List<Profile> get allUsers => _allUsers;
  List<Profile> _bookMarkPost=[];
  List<Profile> get bookMarkPost= _bookMarkPost;
  //My profile
  Profile _myProfile = Profile(
      name: '',
      id: '',
      photo: 'https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206',
      email: '',
      subscribers: [],
      subscribing: [],
      bookmark: [],
      profession: "",
      uid: '');

  Profile get myProfile => _myProfile;

  //Other user profile
  Profile _otherProfile = Profile(
      name: '',
      id: ' ',
      photo: 'https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206',
      email: '',
      subscribers: [],
      subscribing: [],
      bookmark: [],
      profession: "",
      uid: ' ');

  Profile get otherProfile => _otherProfile;

  StreamSubscription<DocumentSnapshot>? _profileSubscription;
  StreamSubscription<QuerySnapshot>? _allUserSubscription;
  Future<void> editProfile(String URL, String name, String  id, String profession) async {
  FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update(<String, dynamic>{
  "image":URL,
  "id": id,
  "name": name,
  "profession": profession,
  });
  notifyListeners();
}
}

  class Profile {
  Profile(
  {required this.name,
  required this.id,
  required this.email,
  required this.photo,
  required this.uid,
  required this.profession,
  required this.subscribers,
  required this.subscribing,
  required this.bookmark,
  });
  String name;
  String id;
  String photo;
  String email;
  String uid;
  String profession;
  List<String> subscribers= [];
  List<String> subscribing= [];
  List<String> bookmark= [];

  }
