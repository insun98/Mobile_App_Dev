// //import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
//
//
// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
//
//
// final userReference = FirebaseFirestore.instance.collection('users');
//
//
// class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage>{
//   // 검색창 입력내용 controller
//   TextEditingController searchTextEditingController = TextEditingController();
//   late Future<QuerySnapshot> futureSearchResults;
//   late CollectionReference database;
//
//
//   @override
//   void initState() {
//     super.initState();
//     database = FirebaseFirestore.instance
//         .collection("user");
//
//     //       .orderBy('price');
//     // }
//   }
//
//   Future<int> countDocuments() async {
//     QuerySnapshot _myDoc =
//     await database.get();
//     List<DocumentSnapshot> _myDocCount = _myDoc.docs;
//     return _myDocCount.length;
//   }
//
//
//
//   emptyTheTextFormField() {
//     searchTextEditingController.clear();
//   }
//
//   controlSearching(str) {
//     Future<QuerySnapshot> allUsers = userReference.where('name', isGreaterThanOrEqualTo: str).get();
//     setState(() {
//       futureSearchResults = allUsers;
//     });
//   }
//
// // 검색페이지 상단부분
//   AppBar searchPageHeader() {
//     return AppBar(
//         backgroundColor: Colors.black,
//         title: TextFormField(
//           controller: searchTextEditingController, // 검색창 controller
//           decoration: InputDecoration(
//               hintText: 'Search here....',
//               hintStyle: TextStyle(
//                 color: Colors.grey,
//               ),
//               enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.grey,)
//               ),
//               focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white,)
//               ),
//               filled: true,
//               prefixIcon: Icon(Icons.person_pin, color: Colors.white, size: 30),
//               suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.white,), onPressed: emptyTheTextFormField)
//           ),
//           style: TextStyle(
//               fontSize: 18,
//               color: Colors.white
//           ),
//           onFieldSubmitted: controlSearching,
//         )
//     );
//   }
//
//   displayNoSearchResultScreen() {
//     return Container(
//         child: Center(
//             child: ListView(
//               shrinkWrap: true,
//               children: <Widget>[
//                 Icon(Icons.group, color: Colors.grey, size: 150),
//                 Text(
//                   'Search Users',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 40
//                   ),
//                 ),
//               ],
//             )
//         )
//     );
//   }
//
//   displayUsersFoundScreen() {
//     return FutureBuilder(
//         future: futureSearchResults,
//         builder: (context, snapshot) {
//           if(!snapshot.hasData) {
//             return circularProgress();
//           }
//
//           List<UserResult> searchUserResult = [];
//           snapshot.data.document.forEach((document) {
//             User users = User.fromDocument(document);
//             UserResult userResult = UserResult(users);
//             searchUserResult.add(userResult);
//           });
//
//           return ListView(
//               children: searchUserResult
//           );
//         }
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: searchPageHeader(),
//       body: futureSearchResults == null ? displayNoSearchResultScreen() : displayUsersFoundScreen(),
//     );
//   }
//
//   // with AutomaticKeepAliveClientMixin를 추가해주고 아래 값을 true로 설정해주면 다른탭 다녀와도 initState안함
//   @override
//   bool get wantKeepAlive => true;
// }
//
// class UserResult extends StatelessWidget {
//   final User eachUser;
//   UserResult(this.eachUser);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.all(3),
//         child: Container(
//           color: Colors.white54,
//           child: Column(
//             children: <Widget>[
//               GestureDetector(
//                 onTap: () {
//                   print('tapped');
//                 },
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.black,
//                    // backgroundImage: eachUser.url == null ? circularProgress() : CachedNetworkImageProvider(eachUser.url,),
//                   ),
//                   title: Text(eachUser.name, style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   )),
//                   subtitle: Text(eachUser.profession, style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 13,
//                   )),
//                 ),
//               )
//             ],
//           ),
//         )
//     );
//   }
// }