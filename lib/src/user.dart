//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class User {
//
//   final String name;
//   final String profession;
//
//   User({
//
//     required this.name,
//     required this.profession,
//   });
//
//   factory User.fromDocument(DocumentSnapshot doc) {
//    Map getDocs = doc.data();
//     return User(
//      // id: doc.id,
//       name: getDocs["name"],
//       profession: getDocs["profession"],
//    //   url: getDocs["url"],
//      // profileName: getDocs["profileName"],
//       //bio: getDocs["bio"],
//     );
//   }
// }