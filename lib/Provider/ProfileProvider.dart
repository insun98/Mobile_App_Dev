import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../firebase_options.dart';
import 'PostProvider.dart';

class ProfileProvider extends ChangeNotifier {
  String _defaultImage = '';
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
    final defaultProPicRef = storageRef.child(filename);
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
          _myProfile.subscribers = snapshot.data()!['subscriber'];
          _myProfile.subscribing = snapshot.data()!['subscribing'];
          _myProfile.bookmark = snapshot.data()!['bookmark'];
          _myProfile.photo = snapshot.data()!['image'];
          _myProfile.uid = snapshot.id;
          _myProfile.profession = snapshot.data()!['profession'];
          notifyListeners();
        }

        print(_myProfile.subscribing.length);
        _subscribingProfile = [];
        for (var subscribingUser in _myProfile.subscribing) {
          FirebaseFirestore.instance
              .collection('user')
              .doc(subscribingUser)
              .snapshots()
              .listen((snapshot) {
            _subscribingProfile.add(Profile(
              name:snapshot.data()!['name'],
              id:snapshot.data()!['id'],
              email:snapshot.data()!['email'],
              uid:snapshot.id,
              bookmark: snapshot.data()!['bookmark'],
              subscribers: snapshot.data()!['subscriber'],
              subscribing: snapshot.data()!['subscribing'], photo: snapshot.data()!['image'], profession: snapshot.data()!['profession'],
            )

            );
            notifyListeners();

        FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          _myBookPost = [];
          if(documentSnapshot.exists) {
            try{
              dynamic book = snapshot.get(FieldPath(['bookmark']));
             // _myBookPost.add(
                print("${book[0]}");
              //);
            }on StateError catch(e){
              print('No field exists!');
            }
          }else{
            print('Document does not exist on the database');
          }
          notifyListeners();
        });
          });


          });
          notifyListeners();
        }

      });
      if(_myProfile.uid == FirebaseAuth.instance.currentUser!.uid) {
        getFriends();
      }

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
              subscribers: document.data()['subscriber'],
              subscribing: document.data()['subscribing'],
              bookmark: document.data()['bookmark'],
              photo: document.data()['image'],
              uid: document.id,
            ),
          );
        }
        notifyListeners();
      });
    });
  }

  Future<bool> getUser(String uid) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() != null) {
        _otherProfile.name = snapshot.data()!['name'];
        _otherProfile.email = snapshot.data()!['email'];
        _otherProfile.id = snapshot.data()!['id'];
        _otherProfile.subscribers = snapshot.data()!['subscriber'];
        _otherProfile.subscribing = snapshot.data()!['subscribing'];
        _otherProfile.bookmark = snapshot.data()!['bookmark'];
        _otherProfile.photo = snapshot.data()!['image'];
        _otherProfile.uid = snapshot.id;
        _otherProfile.profession = snapshot.data()!['profession'];
        notifyListeners();
      }
    });


    if(_otherProfile.subscribers.contains(uid)){
      return true;
    }
    return false;
  }
   getFriends()  {

    for (var subscribingUser in myProfile.subscribing) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(subscribingUser)
          .snapshots()
          .listen((snapshot) {
        subscribingProfile.add(Profile(
             name:snapshot.data()!['name'],
              id:snapshot.data()!['id'],
        email:snapshot.data()!['email'],
        uid:snapshot.id,
        bookmark: snapshot.data()!['bookmark'],
        subscribers: snapshot.data()!['subscriber'],
        subscribing: snapshot.data()!['subscribing'], photo: snapshot.data()!['image'], profession: snapshot.data()!['profession'],
        )

          );

        });
      }
    }

  // Future<void> getFriends() async {
  //   for (var subscribingUser in myProfile.subscribing) {
  //     FirebaseFirestore.instance
  //         .collection('user')
  //         .doc(subscribingUser)
  //         .get()
  //         .then((value) {
  //       _subscribingProfile.add(Profile(
  //           name: value.data()!['name'],
  //           id: value.data()!['id'],
  //           email: value.data()!['email'],
  //           photo: value.data()!['image'],
  //           uid: value.id,
  //           profession: value.data()!['profession'],
  //           subscribers: [],
  //           subscribing: [],
  //           bookmark: [])
  //
  //       );
  //       notifyListeners();
  //       print(value.data()!['name']);
  //     });
  //   }
  // }

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
  List<Profile> _subscribingProfile = [];
  List<Profile> get subscribingProfile => _subscribingProfile;
  List<Profile> _allUsers = [];
  List<Profile> get allUsers => _allUsers;

  List<Profile> _bookMarkPost = [];
  List<Profile> get bookMarkPost => _bookMarkPost;


  List<String> _myBookPost = [];
  List<String> get myBookPost => _myBookPost;

  //My profile
  Profile _myProfile = Profile(
      name: '',
      id: '',
      photo:
          'https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206',
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
      photo:
          'https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206',
      email: '',
      subscribers: [],
      subscribing: [],
      bookmark: [],
      profession: "",
      uid: ' ');

  Profile get otherProfile => _otherProfile;

  StreamSubscription<DocumentSnapshot>? _profileSubscription;
  StreamSubscription<QuerySnapshot>? _allUserSubscription;
  Future<void> editProfile(
      String URL, String name, String id, String profession) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(<String, dynamic>{
      "image": URL,
      "id": id,
      "name": name,
      "profession": profession,
    });
    notifyListeners();
  }
}

class Profile {

  Profile(
  {

    required this.name,
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

  List<dynamic> subscribers;
  List<dynamic> subscribing;
  List<dynamic> bookmark;

}
