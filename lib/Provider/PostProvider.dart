import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../firebase_options.dart';

class PostProvider extends ChangeNotifier {
  String _defaultImage = '';
  PostProvider() {
    init();
  }
  List<Post> _myPost = [];
  List<Post> get myPost => _myPost;
  List<Post> _allPosts = [];
  List<Post> get allPosts => _allPosts;
  List<Post> _typePosts = [];
  List<Post> get typePosts => _typePosts;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    StreamSubscription<QuerySnapshot>? _myPostSubscription;
    StreamSubscription<QuerySnapshot>? _allPostSubscription;
    StreamSubscription<QuerySnapshot>? _postSubscription;
    final storageRef = FirebaseStorage.instance.ref();
    final filename = "defaultProfile.png";
    final defaultProPicRef = storageRef.child(filename);

    final downloadUrl = await defaultProPicRef.getDownloadURL();
    _defaultImage = downloadUrl;

    FirebaseAuth.instance.userChanges().listen((user) {
      //Read only my posts
      _myPostSubscription = FirebaseFirestore.instance
          .collection('post')
          .where('creator', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((snapshot) {
        _myPost = [];
        for (final document in snapshot.docs) {
          _myPost.add(
            Post(
              docId: document.id,
              title: document.data()['title'] as String,
              image: document.data()['image'],
              description: document.data()['description'] as String,
              type: document.data()['type'] as String,
              create: document.data()['create'],
              modify: document.data()['modify'],
              creator: document.data()['creator'] as String,
              price: document.data()['price'],
              like: document.data()['like'],
              likeUsers: document.data()['likeUsers'],
            ),
          );
          notifyListeners();
          print(document.data()['image']);
        }
        notifyListeners();
      });

      //read All posts
      _allPostSubscription = FirebaseFirestore.instance
          .collection('post')
          .snapshots()
          .listen((snapshot) {
        _allPosts = [];
        for (final document in snapshot.docs) {
          _allPosts.add(
            Post(
              docId: document.id,
              title: document.data()['title'] as String,
              image: document.data()['image'],
              description: document.data()['description'] as String,
              type: document.data()['type'] as String,
              create: document.data()['create'],
              modify: document.data()['modify'],
              creator: document.data()['creator'] as String,
              price: document.data()['price'],
              like: document.data()['like'],
              likeUsers: document.data()['likeUsers'],
            ),
          );
          print(document.data()['image']);
        }
        notifyListeners();
      });


    });
  }

  Future<void> getTypePost(String std) async {
    FirebaseFirestore.instance
        .collection('post')
        .snapshots()
        .listen((snapshot) {
      _typePosts = [];
      for (final document in snapshot.docs) {
        if (document.data()['type'] == std) {
          _typePosts.add(
            Post(
              docId: document.id,
              title: document.data()['title'] as String,
              image: document.data()['image'],
              description: document.data()['description'] as String,
              type: document.data()['type'] as String,
              create: document.data()['create'],
              modify: document.data()['modify'],
              creator: document.data()['creator'] as String,
              price: document.data()['price'],
              like: document.data()['like'],
              likeUsers: document.data()['likeUsers'],
            ),
          );
        }
      }
    });
    notifyListeners();
  }
  Future<void> getTimePost(String time) async {
    FirebaseFirestore.instance
        .collection('post')
        .snapshots()
        .listen((snapshot) {
      _typePosts = [];
      for (final document in snapshot.docs) {
        if (document.data()['type'] == time) {
          _typePosts.add(
            Post(
              docId: document.id,
              title: document.data()['title'] as String,
              image: document.data()['image'],
              description: document.data()['description'] as String,
              type: document.data()['type'] as String,
              create: document.data()['create'],
              modify: document.data()['modify'],
              creator: document.data()['creator'] as String,
              price: document.data()['price'],
              like: document.data()['like'],
              likeUsers: document.data()['likeUsers'],
            ),
          );
        }
      }
    });
    notifyListeners();
  }

  Future<void> updateDoc(String docID, int like, bool islike) async {
    FirebaseFirestore.instance
        .collection("post")
        .doc(docID)
        .update(<String, dynamic>{
      "like": like,
      "islike": islike,
    });
    notifyListeners();
  }

  Future<void> updatebook(String postID) async {
    FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{
      "bookmark": FieldValue.arrayUnion([postID]),
    });
    notifyListeners();
  }
  Future<void> deletebook(String postID) async {
    FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).update(<String, dynamic>{
      "bookmark": FieldValue.arrayRemove([postID]),
    });
    notifyListeners();
  }



  Future<String> UploadFile(File image) async {
    final storageRef = FirebaseStorage.instance.ref();
    final filename = "${DateTime.now().millisecondsSinceEpoch}.png";
    final mountainsRef = storageRef.child(filename);
    final mountainImagesRef = storageRef.child("images/${filename}");
    File file = File(image.path);
    await mountainsRef.putFile(file);
    final downloadUrl = await mountainsRef.getDownloadURL();
    return downloadUrl;
  }

  Future<DocumentReference> addPost(
      String URL, String type, String title, int price, String description) {
    return FirebaseFirestore.instance.collection('post').add(<String, dynamic>{
      'image': URL,
      'type': type,
      'title': title,
      'price': price,
      'description': description,
      'like':0,
      'likeUsers':[],
      'create': FieldValue.serverTimestamp(),
      'modify': FieldValue.serverTimestamp(),
      'creator': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}

class Post {
  Post(
      {required this.docId,
        required this.image,
        required this.title,
        required this.price,
        required this.like,
        required this.likeUsers,
        required this.type,
        required this.description,
        required this.create,
        required this.modify,
        required this.creator});
  String docId;
  String image;
  String title;
  int price;
  List<dynamic> likeUsers;
  int like;
  String type;
  String description;
  Timestamp create;
  Timestamp modify;
  String creator;
}