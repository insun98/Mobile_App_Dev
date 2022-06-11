import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
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

        FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          _myBookPost = [];
          if (documentSnapshot.exists) {
            try {
              dynamic book = snapshot.get(FieldPath(['bookmark']));
              // _myBookPost.add(

              //);
            } on StateError catch (e) {
              print('No field exists!');
            }
          } else {
            print('Document does not exist on the database');
          }
          notifyListeners();
        });

        print(_myProfile.subscribing.length);
        _subscribingProfile = [];
        for (var subscribingUser in _myProfile.subscribing) {
          FirebaseFirestore.instance
              .collection('user')
              .doc(subscribingUser)
              .snapshots()
              .listen((snapshot) {
            _subscribingProfile.add(Profile(
              name: snapshot.data()!['name'],
              id: snapshot.data()!['id'],
              email: snapshot.data()!['email'],
              uid: snapshot.id,
              bookmark: snapshot.data()!['bookmark'],
              subscribers: snapshot.data()!['subscriber'],
              subscribing: snapshot.data()!['subscribing'],
              photo: snapshot.data()!['image'],
              profession: snapshot.data()!['profession'],
            ));
            notifyListeners();
          });
          notifyListeners();
        }

      });
      _bookMarkPost = [];
      for (var userBookMark in _myProfile.bookmark) {
        FirebaseFirestore.instance
            .collection('post')
            .doc(userBookMark)
            .snapshots()
            .listen((snapshot) {
          _bookMarkPost.add(Post(
            docId: snapshot.id,
            title: snapshot.data()!['title'],
            image: snapshot.data()!['image'],
            description: snapshot.data()!['description'] as String,
            type: snapshot.data()!['type'] as String,
            create: snapshot.data()!['create'],
            modify: snapshot.data()!['modify'],
            creator: snapshot.data()!['creator'] as String,
            creatorId: snapshot.data()!['creatorId'] as String,
            creatorImage: snapshot.data()!['creatorImage'] as String,

            like: snapshot.data()!['like'],
            likeUsers: snapshot.data()!['likeUsers'],
            lat: snapshot.data()!['lat'],
            lng: snapshot.data()!['lng'],
            duration: snapshot.data()!['duration'],
            amount: snapshot.data()!['amount'],
            blog: snapshot.data()!['blog'],
            intro: snapshot.data()!['intro'],
            date: DateFormat('yyyy-MM-dd HH:mm:ss').format(snapshot.data()!['date'].toDate()),
            share: snapshot.data()!['share'],
            ingredients: snapshot.data()!['ingredients'],
          ));
        });
      }

      if (_myProfile.uid == FirebaseAuth.instance.currentUser!.uid) {
        getFriends();
        getBook();
      }

      _rankSubscription = FirebaseFirestore.instance
          .collection('user')
          .orderBy('followers', descending: true)
          .limit(3)
          .snapshots()
          .listen((snapshot) {
        _rankUsers = [];
        for (final document in snapshot.docs) {
          _rankUsers.add(
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
    print("ssgood");
     FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get().then((snapshot) {
       _otherProfile = Profile(
           name: '',
           id: ' ',
           photo: '',
           email: '',
           subscribers: [],
           subscribing: [],
           bookmark: [],
           profession: "",
           uid: ' ');
       _isSubscribed = false;
       if (snapshot.data() != null) {
         _otherProfile.subscribers = snapshot.data()!['subscriber'];
         _otherProfile.name = snapshot.data()!['name'];
         _otherProfile.email = snapshot.data()!['email'];
         _otherProfile.id = snapshot.data()!['id'];

         _otherProfile.subscribing = snapshot.data()!['subscribing'];
         _otherProfile.bookmark = snapshot.data()!['bookmark'];
         _otherProfile.photo = snapshot.data()!['image'];
         _otherProfile.uid = snapshot.id;
         _otherProfile.profession = snapshot.data()!['profession'];
       }
       notifyListeners();

     });





    if (_myProfile.subscribing.contains(_otherProfile.uid)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addSubscriber(String uid) async {
    var val = [];
    val.add(FirebaseAuth.instance.currentUser!.uid);
    FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .update({"subscriber": FieldValue.arrayUnion(val)});
    val = [];
    val.add(uid);

    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"subscribing": FieldValue.arrayUnion(val)});
    _isSubscribed = true;

    notifyListeners();

  }

  getFriends() {
    _subscribingProfile = [];
    for (var subscribingUser in _myProfile.subscribing) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(subscribingUser)
          .snapshots()
          .listen((snapshot) {
        _subscribingProfile.add(Profile(
          name: snapshot.data()!['name'],
          id: snapshot.data()!['id'],
          email: snapshot.data()!['email'],
          uid: snapshot.id,
          bookmark: snapshot.data()!['bookmark'],
          subscribers: snapshot.data()!['subscriber'],
          subscribing: snapshot.data()!['subscribing'],
          photo: snapshot.data()!['image'],
          profession: snapshot.data()!['profession'],
        ));
        notifyListeners();
      });
    }
  }
  getBook() {
    _bookMarkPost = [];
    for (var userBookMark in _myProfile.bookmark) {
      FirebaseFirestore.instance
          .collection('post')
          .doc(userBookMark)
          .snapshots()
          .listen((snapshot) {
        _bookMarkPost.add(Post(
          docId: snapshot.id,
          title: snapshot.data()!['title'],
          image: snapshot.data()!['image'],
          description: snapshot.data()!['description'] as String,
          type: snapshot.data()!['type'] as String,
          create: snapshot.data()!['create'],
          modify: snapshot.data()!['modify'],
          creator: snapshot.data()!['creator'] as String,
          creatorId: snapshot.data()!['creatorId'] as String,
          creatorImage: snapshot.data()!['creatorImage'] as String,

          like: snapshot.data()!['like'],
          likeUsers: snapshot.data()!['likeUsers'],
          lat: snapshot.data()!['lat'],
          lng: snapshot.data()!['lng'],
          duration: snapshot.data()!['duration'],
          amount: snapshot.data()!['amount'],
          blog: snapshot.data()!['blog'],
          intro: snapshot.data()!['intro'],
          date: DateFormat('yyyy-MM-dd HH:mm:ss').format(snapshot.data()!['date'].toDate()),
          share: snapshot.data()!['share'],
          ingredients: snapshot.data()!['ingredients'],
        ));
      });
    }
  }

  bool? _checkUser;
  List<Profile> _subscribingProfile = [];
  List<Profile> get subscribingProfile => _subscribingProfile;
  List<Profile> _allUsers = [];
  List<Profile> _rankUsers = [];

  List<Profile> get allUsers => _allUsers;
  List<Profile> get rankUsers => _rankUsers;

  List<Post> _bookMarkPost = [];
  List<Post> get bookMarkPost => _bookMarkPost;

  List<Post> _myBookPost = [];
  List<Post> get myBookPost => _myBookPost;

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
      photo: '',
      email: '',
      subscribers: [],
      subscribing: [],
      bookmark: [],
      profession: "",
      uid: ' ');

  Profile get otherProfile => _otherProfile;
  bool _isSubscribed = false;
  bool get isSubscribed => _isSubscribed;
  void set isSubscribedSet(bool check) {
    _isSubscribed = check;
  }

  StreamSubscription<DocumentSnapshot>? _profileSubscription;
  StreamSubscription<QuerySnapshot>? _allUserSubscription;
  StreamSubscription<QuerySnapshot>? _rankSubscription;

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
  Profile({
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
