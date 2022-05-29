// import 'dart:async';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import '../firebase_options.dart';
//
//
// class ApplicationState extends ChangeNotifier {
//
//   String _defaultImage='';
//   ApplicationState() {
//     init();
//   }
//
//   Future<void> init() async {
//
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     StreamSubscription<DocumentSnapshot>? _profileSubscription;
//     StreamSubscription<QuerySnapshot>? ItemSubscription;
//     StreamSubscription<QuerySnapshot>? _userSubscription;
//     StreamSubscription<QuerySnapshot>? PostSubscription;
//     final storageRef = FirebaseStorage.instance.ref();
//     final filename = "defaultProfile.png";
//     final  defaultProPicRef = storageRef.child(filename);
//
//
//     final downloadUrl = await defaultProPicRef.getDownloadURL();
//     _defaultImage = downloadUrl;
//
//
//     FirebaseAuth.instance.userChanges().listen((user) {
//       _profileSubscription = FirebaseFirestore.instance
//           .collection('user')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .snapshots()
//           .listen((snapshot) {
//         if (snapshot.data() != null) {
//           _profile.name = snapshot.data()!['name'];
//           _profile.email = snapshot.data()!['email'];
//           _profile.subscribers = snapshot.data()!['subscribers'];
//           _profile.subscribing = snapshot.data()!['subscribing'];
//           _profile.bookmark = snapshot.data()!['bookmark'];
//           _profile.photo = snapshot.data()!['image'];
//           _profile.uid = snapshot.data()!['uid'];
//           notifyListeners();
//         }
//       });
//
//       ItemSubscription = FirebaseFirestore.instance
//           .collection('post')
//           .where('creator', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//           .snapshots()
//           .listen((snapshot) {
//         _MyPost = [];
//         for (final document in snapshot.docs) {
//           _MyPost.add(
//             Post(
//               docId: document.id,
//               title: document.data()['title'] as String,
//               image: document.data()['image'],
//               description: document.data()['description'] as String,
//               type: document.data()['type'] as String,
//               create: document.data()['create'],
//               modify: document.data()['modify'],
//               creator: document.data()['creator'] as String,
//               price: document.data()['price'],
//               like: document.data()['like'],
//               islike: document.data()['islike'],
//             ),
//           );
//           print(document.data()['image']);
//         }
//         notifyListeners();
//       });
//
//       PostSubscription = FirebaseFirestore.instance
//           .collection('post')
//           .orderBy('like', descending: true)
//           .snapshots()
//           .listen((snapshot) {
//         _MyPosts = [];
//         for (final document in snapshot.docs) {
//           _MyPosts.add(
//             Post(
//               docId: document.id,
//               title: document.data()['title'] as String,
//               image: document.data()['image'],
//               description: document.data()['description'] as String,
//               type: document.data()['type'] as String,
//               create: document.data()['create'],
//               modify: document.data()['modify'],
//               creator: document.data()['creator'] as String,
//               price: document.data()['price'],
//               like: document.data()['like'],
//               islike: document.data()['islike'],
//             ),
//           );
//           print(document.data()['image']);
//         }
//         notifyListeners();
//       });
//
//       _userSubscription = FirebaseFirestore.instance
//           .collection('user')
//           .snapshots()
//           .listen((snapshot) {
//         _MyPost = [];
//         for (final document in snapshot.docs) {
//           _MyPost.add(
//             Post(
//               docId: document.id,
//               title: document.data()['title'] as String,
//               image: document.data()['image'],
//               description: document.data()['description'] as String,
//               type: document.data()['type'] as String,
//               create: document.data()['create'],
//               modify: document.data()['modify'],
//               creator: document.data()['creator'] as String,
//               price: document.data()['price'],
//               like: document.data()['like'],
//               islike: document.data()['islike'],
//             ),
//           );
//           print(document.data()['image']);
//         }
//         notifyListeners();
//       });
//
//     });}
//
//   Future<void> set() async {
//     FirebaseFirestore.instance
//         .collection('user')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .snapshots()
//         .listen((snapshot) {
//       if (snapshot.data() != null) {
//         _profile.name = snapshot.data()!['name'];
//         _profile.email = snapshot.data()!['email'];
//         _profile.id = snapshot.data()!['id'];
//         _profile.subscribers = snapshot.data()!['subscribers'];
//         _profile.bookmark = snapshot.data()!['bookmark'];
//         _profile.photo = snapshot.data()!['image'];
//         _profile.uid = snapshot.data()!['uid'];
//         notifyListeners();
//       }
//     });
//   }
//
//   Future<void> getTypePost(String std) async {
//     FirebaseFirestore.instance
//         .collection('post')
//         .snapshots()
//         .listen((snapshot) {
//       _MyPosts = [];
//       for (final document in snapshot.docs) {
//         if(document.data()['type'] == std) {
//           _MyPosts.add(
//             Post(
//               docId: document.id,
//               title: document.data()['title'] as String,
//               image: document.data()['image'],
//               description: document.data()['description'] as String,
//               type: document.data()['type'] as String,
//               create: document.data()['create'],
//               modify: document.data()['modify'],
//               creator: document.data()['creator'] as String,
//               price: document.data()['price'],
//               like: document.data()['like'],
//               islike: document.data()['islike'],
//             ),
//           );
//         }
//       }
//
//     });
//     notifyListeners();
//   }
//
//   Future<void> updateDoc(String docID, int like, bool islike) async {
//     FirebaseFirestore.instance.collection("post").doc(docID).update(<String, dynamic>{
//       "like": like,
//       "islike": islike,
//     });
//     notifyListeners();
//   }
//
//   Future<void> getPosts(String std) async {
//     FirebaseFirestore.instance
//         .collection('user')
//         .orderBy(std, descending: false)
//         .snapshots()
//         .listen((snapshot) {
//       _MyPost = [];
//       for (final document in snapshot.docs) {
//         _MyPost.add(
//           Post(
//             docId: document.id,
//             title: document.data()['title'] as String,
//             image: document.data()['image'],
//             description: document.data()['description'] as String,
//             type: document.data()['type'] as String,
//             create: document.data()['create'],
//             modify: document.data()['modify'],
//             creator: document.data()['creator'] as String,
//             price: document.data()['price'],
//             like: document.data()['like'],
//             islike: document.data()['islike'],
//           ),
//         );
//       }
//
//     });
//     notifyListeners();
//   }
//   Future<bool> getFriend(String uid) async {
//     bool check = true;
//     FirebaseFirestore.instance
//         .collection('user')
//         .doc(uid)
//         .snapshots()
//         .listen((snapshot) {
//       if (snapshot.data() != null) {
//         _friendprofile.name = snapshot.data()!['name'];
//         _friendprofile.email = snapshot.data()!['email'];
//         _friendprofile.subscribers = snapshot.data()!['subscribers'];
//         _friendprofile.subscribing = snapshot.data()!['subscribing'];
//         _friendprofile.bookmark = snapshot.data()!['bookmark'];
//         _friendprofile.photo = snapshot.data()!['image'];
//         _friendprofile.uid = snapshot.data()!['uid'];
//         notifyListeners();
//
//       }
//
//     });
//     return check;
//   }
//   bool? _checkUser;
//
//   Profile _profile = Profile(
//       name: '',
//       id: ' ',
//       photo: 'https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206',
//       email: '',
//       subscribers: [],
//       subscribing: [],
//       bookmark: [],
//       profession: "",
//       uid: ' ');
//   Profile _friendprofile = Profile(
//       name: '',
//       id: ' ',
//       photo: 'https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206',
//       email: '',
//       subscribers: [],
//       subscribing: [],
//       bookmark: [],
//       profession: "",
//       uid: ' ');
//   Profile get profile => _profile;
//   Profile get friendProfile => _profile;
//   Future<bool?> verifyEmail(
//       String email,
//
//       void Function(FirebaseAuthException e) errorCallback,
//       ) async {
//     try {
//       var methods =
//       await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
//       if (methods.contains('password')) {
//
//         _checkUser = true;
//       } else {
//         _checkUser = false;
//       }
//
//       notifyListeners();
//     } on FirebaseAuthException catch (e) {
//       errorCallback(e);
//     }
//     return _checkUser;
//   }
//
//   Future<void> signInWithEmailAndPassword(
//
//       String email,
//       String password,
//       void Function(FirebaseAuthException e) errorCallback,
//       ) async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//     } on FirebaseAuthException catch (e) {
//       errorCallback(e);
//     }
//     notifyListeners();
//
//   }
//
//
//
//   Future<void> registerAccount(
//       String email,
//       String id,
//       String password,
//       String name,
//       String profession,
//       void Function(FirebaseAuthException e) errorCallback) async {
//     try {
//       var credential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       await credential.user!.updateDisplayName(id);
//     } on FirebaseAuthException catch (e) {
//       errorCallback(e);
//     }
//     FirebaseFirestore.instance
//         .collection('user')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .set(<String, dynamic>{
//       'image':"https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206",
//       'email': email,
//       'name': name,
//       'id': id,
//       'profession':profession,
//       'password': password,
//       'subscriber':[],
//       'subscribing':[],
//       'bookmark' : [],
//     });
//
//   }
//   List<Post> _MyPost = [];
//   List<Post> get MyPost => _MyPost;
//   List<Post> _MyPosts = [];
//   List<Post> get MyPosts => _MyPosts;
//   List<Post> _MyPostbook = [];
//   List<Post> get MyPostbook => _MyPostbook;
//
//
//   Future<String> UploadFile(File image) async {
//     final storageRef = FirebaseStorage.instance.ref();
//     final filename = "${DateTime.now().millisecondsSinceEpoch}.png";
//     final mountainsRef = storageRef.child(filename);
//     final mountainImagesRef = storageRef.child("images/${filename}");
//     File file = File(image.path);
//     await mountainsRef.putFile(file);
//     final downloadUrl = await mountainsRef.getDownloadURL();
//     return downloadUrl;
//   }
//
//   Future<DocumentReference> addItem(
//       String URL, String type,String title, int price, String description) {
//     return FirebaseFirestore.instance
//         .collection('post')
//         .add(<String, dynamic>{
//       'image': URL,
//       'type': type,
//       'title': title,
//       'price': price,
//       'description': description,
//       'create': FieldValue.serverTimestamp(),
//       'modify': FieldValue.serverTimestamp(),
//       'creator': FirebaseAuth.instance.currentUser!.uid,
//     });
//   }
//   void signOut() {
//     FirebaseAuth.instance.signOut();
//     notifyListeners();
//   }
//
//
// }
//
// class Profile {
//   Profile(
//       {required this.name,
//         required this.id,
//         required this.email,
//         required this.photo,
//         required this.uid,
//         required this.profession,
//         required this.subscribers,
//         required this.subscribing,
//         required this.bookmark,
//       });
//   String name;
//   String id;
//   String photo;
//   String email;
//   String uid;
//   String profession;
//   List<String> subscribers= [];
//   List<String> subscribing= [];
//   List<String> bookmark= [];
//
// }
// class Post {
//   Post(
//       {required this.docId,
//         required this.image,
//         required this.title,
//         required this.price,
//         required this.like,
//         required this.islike,
//         required this.type,
//         required this.description,
//         required this.create,
//         required this.modify,
//         required this.creator});
//   String docId;
//   String image;
//   String title;
//   int price;
//   int like;
//   bool islike;
//   String type;
//   String description;
//   Timestamp create;
//   Timestamp modify;
//   String creator;
// }