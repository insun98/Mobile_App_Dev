import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
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
  List<Post> _orderPosts = [];

  List<Post> get orderPosts => _orderPosts;
  List<Post> _typePosts = [];

  List<Post> get typePosts => _typePosts;

  List<Post> _frinedPost = [];

  List<Post> get frinedPost => _frinedPost;

  List<Post> _bookPosts = [];

  List<Post> get bookPosts => _bookPosts;

  Post _singlePost = Post(
    docId: "",
    image: "",
    title: "",
    like: 0,
    likeUsers: [],
    type: "",
    description: "",
    create: Timestamp.now(),
    modify: Timestamp.now(),
    creator: "",
    creatorId: "",
    creatorImage: '',
    lat: 0.0,
    lng: 0.0,
    amount: 0,
    duration: 0,
    blog: "",
    intro: "",
    date: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    share: false,
    ingredients: "",
  );

  Post get singlePost => _singlePost;

  Post _specPost = Post(
      docId: "",
      image: "",
      title: "",
      like: 0,
      likeUsers: [],
      type: "",
      description: "",
      create: Timestamp.now(),
      modify: Timestamp.now(),
      creator: "",
      creatorId: "",
      creatorImage: '',
      lat: 0.0,
      lng: 0.0,
      amount: 0,
      duration: 0,
      blog: "",
      intro: "",
      date: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      share: false,
      ingredients: "");
  Post get specPost => _specPost;

  List<String> _likeList = [];
  List<String> get likeList => _likeList;

  List<Marker> _mapPost = [];

  List<Marker> get mapPost => _mapPost;
  bool like = false;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    StreamSubscription<QuerySnapshot>? _myPostSubscription;
    StreamSubscription<QuerySnapshot>? _allPostSubscription;
    StreamSubscription<QuerySnapshot>? _orderPostSubscription;
    StreamSubscription<QuerySnapshot>? _postSubscription;
    StreamSubscription<QuerySnapshot>? _mapSubscription;
    final storageRef = FirebaseStorage.instance.ref();
    final filename = "defaultProfile.png";
    final defaultProPicRef = storageRef.child(filename);

    final downloadUrl = await defaultProPicRef.getDownloadURL();
    _defaultImage = downloadUrl;
    _allPostSubscription = FirebaseFirestore.instance
        .collection('post')
        .where('share', isEqualTo: true)
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
            creatorId: document.data()['creatorId'] as String,
            creatorImage: document.data()['creatorImage'] as String,

            like: document.data()['like'],
            likeUsers: document.data()['likeUsers'],
            lat: document.data()['lat'],
            lng: document.data()['lng'],
            duration: document.data()['duration'],
            amount: document.data()['amount'],
            blog: document.data()['blog'],
            intro: document.data()['intro'],
            date: DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(document.data()['date'].toDate()),
            share: document.data()['date'].microsecondsSinceEpoch <
                Timestamp.now().microsecondsSinceEpoch
                ? false
                : true,
            ingredients: document.data()['ingredients'],
          ),
        );
        notifyListeners();
      }
      notifyListeners();
    });
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
              creatorId: document.data()['creatorId'] as String,
              creatorImage: document.data()['creatorImage'] as String,
              like: document.data()['like'],
              likeUsers: document.data()['likeUsers'],
              lat: document.data()['lat'],
              lng: document.data()['lng'],
              duration: document.data()['duration'],
              amount: document.data()['amount'],
              blog: document.data()['blog'],
              intro: document.data()['intro'],
              date: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(document.data()['date'].toDate()),
              share: document.data()['date'].microsecondsSinceEpoch <
                      Timestamp.now().microsecondsSinceEpoch
                  ? false
                  : true,
              ingredients: document.data()['ingredients'],
            ),
          );
          notifyListeners();
        }
        notifyListeners();
      });
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
              creatorId: document.data()['creatorId'] as String,
              creatorImage: document.data()['creatorImage'] as String,
              like: document.data()['like'],
              likeUsers: document.data()['likeUsers'],
              lat: document.data()['lat'],
              lng: document.data()['lng'],
              duration: document.data()['duration'],
              amount: document.data()['amount'],
              blog: document.data()['blog'],
              intro: document.data()['intro'],
              date: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(document.data()['date'].toDate()),
              share: document.data()['date'].microsecondsSinceEpoch <
                  Timestamp.now().microsecondsSinceEpoch
                  ? false
                  : true,
              ingredients: document.data()['ingredients'],
            ),
          );
          notifyListeners();
        }
        notifyListeners();
      });

      _orderPostSubscription = FirebaseFirestore.instance
          .collection('post')
          .orderBy('like', descending: true)
          .snapshots()
          .listen((snapshot) {
        _orderPosts = [];
        for (final document in snapshot.docs) {
          _orderPosts.add(
            Post(
              docId: document.id,
              title: document.data()['title'] as String,
              image: document.data()['image'],
              description: document.data()['description'] as String,
              type: document.data()['type'] as String,
              create: document.data()['create'],
              modify: document.data()['modify'],
              creator: document.data()['creator'] as String,
              creatorId: document.data()['creatorId'] as String,
              creatorImage: document.data()['creatorImage'] as String,
              like: document.data()['like'],
              likeUsers: document.data()['likeUsers'],
              lat: document.data()['lat'],
              lng: document.data()['lng'],
              duration: document.data()['duration'],
              amount: document.data()['amount'],
              blog: document.data()['blog'],
              intro: document.data()['intro'],
              date: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(document.data()['date'].toDate()),
              share: document.data()['date'].microsecondsSinceEpoch <
                      Timestamp.now().microsecondsSinceEpoch
                  ? false
                  : true,
              ingredients: document.data()['ingredients'],
            ),
          );
          notifyListeners();
        }
        notifyListeners();
      });
    });
  }

  Future<void> getPost(String uid) async {
    FirebaseFirestore.instance
        .collection('post')
        .where('creator', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      _frinedPost = [];
      for (final document in snapshot.docs) {
        _frinedPost.add(
          Post(
            docId: document.id,
            title: document.data()['title'] as String,
            image: document.data()['image'],
            description: document.data()['description'] as String,
            type: document.data()['type'] as String,
            create: document.data()['create'],
            modify: document.data()['modify'],
            creator: document.data()['creator'] as String,
            creatorId: document.data()['creatorId'] as String,
            creatorImage: document.data()['creatorImage'] as String,
            like: document.data()['like'],
            likeUsers: document.data()['likeUsers'],
            lat: document.data()['lat'],
            lng: document.data()['lng'],
            duration: document.data()['duration'],
            amount: document.data()['amount'],
            blog: document.data()['blog'],
            intro: document.data()['intro'],
            date: DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(document.data()['date'].toDate()),
            share: document.data()['date'].microsecondsSinceEpoch <
                    Timestamp.now().microsecondsSinceEpoch
                ? false
                : true,
            ingredients: document.data()['ingredients'],
          ),
        );
        notifyListeners();
      }
      notifyListeners();
    });
  }

  Future<void> getSinglePost(String docId) async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(docId)
        .snapshots()
        .listen((snapshot) {
      _singlePost = Post(
          docId: "",
          image: "",
          title: "",
          like: 0,
          likeUsers: [],
          type: "",
          description: "",
          create: Timestamp.now(),
          modify: Timestamp.now(),
          creator: "",
          creatorId: "",
          creatorImage: '',
          lat: 0.0,
          lng: 0.0,
          duration: 0,
          amount: 0,
          blog: "",
          date: DateTime.now().toString(),
          intro: "",
          share: true,
          ingredients: "");

      if (snapshot.data() != null) {
        _singlePost.docId = snapshot.id;
        _singlePost.image = snapshot.data()!['image'];
        _singlePost.title = snapshot.data()!['title'];
        _singlePost.like = snapshot.data()!['like'];
        _singlePost.likeUsers = snapshot.data()!['likeUsers'];
        _singlePost.type = snapshot.data()!['type'];
        _singlePost.description = snapshot.data()!['description'];
        _singlePost.create = snapshot.data()!['create'];
        _singlePost.modify = snapshot.data()!['modify'];
        _singlePost.creator = snapshot.data()!['creator'];
        _singlePost.creatorId = snapshot.data()!['creatorId'];
        _singlePost.duration = snapshot.data()!['duration'];
        _singlePost.amount = snapshot.data()!['amount'];
        _singlePost.ingredients = snapshot.data()!['ingredients'];

        _singlePost.share = snapshot.data()!['date'].microsecondsSinceEpoch <
                Timestamp.now().microsecondsSinceEpoch
            ? false
            : true;
        _singlePost.date = DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(snapshot.data()!['date'].toDate());
        _singlePost.lat = snapshot.data()!['lat'];
        _singlePost.lng = snapshot.data()!['lng'];
        _singlePost.intro = snapshot.data()!['intro'];
        _singlePost.blog = snapshot.data()!['blog'];
      }
      notifyListeners();
      if (snapshot.data()!['date'].microsecondsSinceEpoch <
          DateTime.now().microsecondsSinceEpoch) {
        FirebaseFirestore.instance
            .collection('post')
            .doc(docId)
            .update(<String, dynamic>{
          'share': false,
        });
        _singlePost.share = false;
        notifyListeners();
      }
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
              creatorId: document.data()['creatorId'] as String,
              creatorImage: document.data()['creatorImage'] as String,
              like: document.data()['like'],
              likeUsers: document.data()['likeUsers'],
              lat: document.data()['lat'],
              lng: document.data()['lng'],
              duration: document.data()['duration'],
              amount: document.data()['amount'],
              blog: document.data()['blog'],
              intro: document.data()['intro'],
              date: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(document.data()['date'].toDate()),
              share: document.data()['date'].microsecondsSinceEpoch <
                      Timestamp.now().microsecondsSinceEpoch
                  ? false
                  : true,
              ingredients: document.data()['ingredients'],
            ),
          ); notifyListeners();
        }
      }
    });
    notifyListeners();
  }

  Future<void> getbookPost(String std) async {
    FirebaseFirestore.instance
        .collection('post')
        .snapshots()
        .listen((snapshot) {
      _bookPosts = [];
      for (final document in snapshot.docs) {
        if (document.id == std) {
          _bookPosts.add(
            Post(
              docId: document.id,
              title: document.data()['title'] as String,
              image: document.data()['image'],
              description: document.data()['description'] as String,
              type: document.data()['type'] as String,
              create: document.data()['create'],
              modify: document.data()['modify'],
              creator: document.data()['creator'] as String,
              creatorId: document.data()['creatorId'] as String,
              creatorImage: document.data()['creatorImage'] as String,
              like: document.data()['like'],
              likeUsers: document.data()['likeUsers'],
              lat: document.data()['lat'],
              lng: document.data()['lng'],
              duration: document.data()['duration'],
              amount: document.data()['amount'],
              blog: document.data()['blog'],
              intro: document.data()['intro'],
              date: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(document.data()['date'].toDate()),
              share: document.data()['date'].microsecondsSinceEpoch <
                      Timestamp.now().microsecondsSinceEpoch
                  ? false
                  : true,
              ingredients: document.data()['ingredients'],
            ),
          );
          notifyListeners();
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
              creatorId: document.data()['creatorId'] as String,
              creatorImage: document.data()['creatorImage'] as String,
              like: document.data()['like'],
              likeUsers: document.data()['likeUsers'],
              lat: document.data()['lat'],
              lng: document.data()['lng'],
              duration: document.data()['duration'],
              amount: document.data()['amount'],
              blog: document.data()['blog'],
              intro: document.data()['intro'],
              date: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(document.data()['date'].toDate()),
              share: document.data()['date'].microsecondsSinceEpoch <
                      Timestamp.now().microsecondsSinceEpoch
                  ? false
                  : true,
              ingredients: document.data()['ingredients'],
            ),
          );
          notifyListeners();
        }
      }
    });
    notifyListeners();
  }

  Future<void> updateDoc(
    String docID,
    int like,
  ) async {
    FirebaseFirestore.instance
        .collection("post")
        .doc(docID)
        .update(<String, dynamic>{
      "like": like + 1,
    });
    notifyListeners();
  }

  Future<void> updatelikeuser(String postID, int like) async {
    FirebaseFirestore.instance
        .collection("post")
        .doc(postID)
        .update(<String, dynamic>{
      "like": like + 1,
    });
    FirebaseFirestore.instance
        .collection("post")
        .doc(postID)
        .update(<String, dynamic>{
      "likeUsers":
          FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
    });
    notifyListeners();
  }

  Future<void> deletelikeuser(String postID, int like) async {
    FirebaseFirestore.instance
        .collection("post")
        .doc(postID)
        .update(<String, dynamic>{
      "like": like - 1,
    });
    FirebaseFirestore.instance
        .collection("post")
        .doc(postID)
        .update(<String, dynamic>{
      "likeUsers":
          FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
    });
    notifyListeners();
  }

  Future<void> updatebook(String postID) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(<String, dynamic>{
      "bookmark": FieldValue.arrayUnion([postID]),
    });
    notifyListeners();
  }

  Future<void> deletebook(String postID) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(<String, dynamic>{
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
  Future<void> editPost(
      String docId,
      String type,
      String title,
      int duration,
      int amount,
      String ingredients,
      String intro,
      String description,
      String blog,

      DateTime date,
      double lat,
      double lng,) async {
    FirebaseFirestore.instance
        .collection("post")
        .doc(docId)
        .update(<String, dynamic>{
      "title": title,
      "duration": duration,
      "amount": amount,
      "ingredients": ingredients,
      'description': description,
      'lat': lat,
      'lng': lng,
      'intro': intro,
      'blog': blog,
      'date': date,
      'share':date.microsecondsSinceEpoch < DateTime.now().microsecondsSinceEpoch?false:true,
    });
    notifyListeners();
  }

  Future<DocumentReference> addPost(
      String URL,
      String type,
      String title,
      int duration,
      int amount,
      String ingredients,
      String description,
      String blog,
      String intro,
      DateTime date,
      double lat,
      double lng,
      String creatorId,
      String creatorImage) {
    return FirebaseFirestore.instance.collection('post').add(<String, dynamic>{
      'image': URL,
      'type': type,
      'title': title,
      'description': description,
      'like': 0,
      'likeUsers': [],
      'create': DateTime.now(),
      'modify': DateTime.now(),
      'creator': FirebaseAuth.instance.currentUser!.uid,
      'creatorId': creatorId,
      'creatorImage': creatorImage,
      'amount': amount,
      'ingredients': ingredients,
      'duration': duration,
      'lat': lat,
      'lng': lng,
      'intro': intro,
      'blog': blog,
      'date': date,
      'share': true,
    });
  }
}

class Post {
  Post({
    required this.docId,
    required this.image,
    required this.title,
    required this.like,
    required this.likeUsers,
    required this.type,
    required this.description,
    required this.create,
    required this.modify,
    required this.creator,
    required this.creatorId,
    required this.creatorImage,
    required this.lat,
    required this.lng,
    required this.duration,
    required this.amount,
    required this.blog,
    required this.intro,
    required this.date,
    required this.share,
    required this.ingredients,
  });
  String docId;
  String image;
  String creatorId;
  String title;
  List<dynamic> likeUsers;
  int like;
  String type;
  String description;
  Timestamp create;
  Timestamp modify;
  String creator;
  String creatorImage;
  double lat;
  double lng;
  int amount;
  int duration;
  String blog;
  String intro;
  String date;
  bool share;
  String ingredients;
}
