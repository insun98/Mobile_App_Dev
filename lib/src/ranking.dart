// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'add.dart';
// import 'profile.dart';
// import 'detail.dart';




class rank extends StatefulWidget {
  final User? user;

  const rank({Key? key, required this.user}) : super(key: key);

  @override
  _rankState createState() => _rankState();
}

class _rankState extends State<rank> {
  late CollectionReference database;

  @override
  void initState() {
    super.initState();
    database = FirebaseFirestore.instance
        .collection('user');
  }

  Future<int> countDocuments() async {
    QuerySnapshot _myDoc =
    await database.get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    return _myDocCount.length;
  }

  // void dialog(
  //     String photoURL, String title, DateTime date, String description) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10.0)),
  //           title: Row(
  //             children: <Widget>[
  //               SizedBox(
  //                 width: 70,
  //                 height: 70,
  //                 child: ClipOval(
  //                   child: Image.network(photoURL, fit: BoxFit.fill),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 194,
  //                 child: Column(
  //                   children: <Widget>[
  //                     Text(
  //                       title,
  //                       style: const TextStyle(fontWeight: FontWeight.bold),
  //                     ),
  //                     const SizedBox(
  //                       height: 5,
  //                     ),
  //                     Text(
  //                       '${DateFormat('yyyy').format(date)}.${date.month}.${date.day} 까지',
  //                       style: const TextStyle(
  //                           fontWeight: FontWeight.bold, fontSize: 14),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Text(
  //                 description,
  //               ),
  //             ],
  //           ),
  //           actions: <Widget>[
  //             SizedBox(
  //               width: 80,
  //               height: 50,
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                     primary: const Color(0xFF5B836A),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(15.0),
  //                     )
  //                 ),
  //                 child: const Text("확인"),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  List<InkWell> _buildListCards(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    final ThemeData theme = Theme.of(context);

    return snapshot.data!.docs.map((DocumentSnapshot document) {
     // DateTime _dateTime =
     // DateTime.parse(document['expirationDate'].toDate().toString());
      return InkWell(
        onTap: () {
          // dialog(document['photoUrl'], document['productName'], _dateTime,
          //     document['description']);
        },
        child: Container(
            margin: const EdgeInsets.only(bottom: 25),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF961D36),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  // child: ClipOval(
                  //   child:
                  //   Image.network(document['image'], fit: BoxFit.fill),
                  // ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 174,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        document['name'],
                        style: theme.textTheme.headline6,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8.0),
                      // Text(
                      //   '${DateFormat('yyyy').format(_dateTime)}.${_dateTime.month}.${_dateTime.day}',
                      //   style: theme.textTheme.subtitle2,
                      // ),
                    ],
                  ),
                ),
                // IconButton(
                //     icon: const Icon(
                //       Icons.delete,
                //     ),
                //     iconSize: 30,
                //     color: Colors.white,
                //     onPressed: () async {
                //       database.doc(document.id).delete();
                //       FirebaseStorage.instance
                //           .refFromURL(document['photoUrl'])
                //           .delete();
                //     }),
              ],
            )),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ranking'),
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.person),
        //   onPressed: () async {
        //     int count = await countDocuments();
        //
        //   },
        // ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: database.orderBy('followers', descending: false).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: Text('wating'),
                    );
                  default:
                    return ListView(
                        padding: const EdgeInsets.all(16.0),
                        children:
                        _buildListCards(context, snapshot) // Changed code
                    );
                }
              },
            ),
          ),
        ],
      ),

      //
      // floatingActionButton: SizedBox(
      //   width: 350,
      //   height: 70,
      //   child: FloatingActionButton.extended(
      //     backgroundColor: const Color(0xFF5B836A),
      //     onPressed: () {
      //     },
      //     label: const Text(
      //       ' k',
      //       style: TextStyle(
      //         color: Colors.white,
      //         fontWeight: FontWeight.bold,
      //         fontSize: 20,
      //       ),
      //     ),
      //     icon: const Icon(
      //       Icons.add,
      //       size: 28,
      //       color: Colors.white,
      //     ),
      //     shape: const RoundedRectangleBorder(
      //       borderRadius: BorderRadius.all(Radius.circular(15.0)),
      //     ),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}



// //수정본
//
//
// class rank extends StatefulWidget {
//   final User? user;
//   const rank({Key? key, required this.user}) : super(key: key);
//
//   // const HomePage({Key? key}) : super(key: key);
//
//
//   @override
//   _rankState createState() => _rankState();
//
// }
// class _rankState extends State<rank> {
//   late CollectionReference database;
//
//   //late query database;
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     database = FirebaseFirestore.instance
//         .collection("user");
//
//     //       .orderBy('price');
//     // }
//   }
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   database = FirebaseFirestore.instance
//   //       .collection('product')
//   //       .doc(widget.user!.uid)
//   //       //.collection('Product');
//   //
//   //
//   // }
//
//   //\ 알수 있음
//   //여기서 get 해줌
//   Future<int> countDocuments() async {
//     QuerySnapshot _myDoc =
//     await database.get();
//     //database 에 컬렉션 데이터 다 넣고 -> get 해서 _mydoc 에불러오고 - 이걸 넣는 list 만들어서
//     List<DocumentSnapshot> _myDocCount = _myDoc.docs;
//     return _myDocCount.length;
//   }
//
// //  List<Card> _buildGridCards(BuildContext context) {
//   List<Card> _buildGridCards(
//       BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
//     //List<Product> products = ProductsRepository.loadProducts(Category.all);
//
//     //  List<Product>products = ProductsRepository.loadProducts(Category.all);
//     //
//     //삭제함
//
//     // if (products.isEmpty) {
//     //   return const <Card>[];
//     // }
//
//
//
//     final ThemeData theme = Theme.of(context);
//     // final NumberFormat formatter = NumberFormat.simpleCurrency(
//     //     locale: Localizations.localeOf(context).toString());
//
//     return snapshot.data!.docs.map((DocumentSnapshot document) {
//       //
//       //여기서 그것의 -> 변수로 document 사용 -> 한개씩
//       //삭제해도됨
//       print("hihi");
//       print(document['name']);
//
//       return Card(
//         clipBehavior: Clip.antiAlias,
//         // TODO: Adjust card heights (103)
//         child: Column(
//           // TODO: Center items on the card (103)
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             AspectRatio(
//               aspectRatio: 18 / 11,
//               child:
//               AspectRatio(
//                 aspectRatio: 18 / 11,
//                 child:
//                 Image.network("https://firebasestorage.googleapis.com/v0/b/finalmo-bb5c6.appspot.com/o/logo.png?alt=media&token=f417a9bc-29eb-4bd2-96ff-f367d86adb9c", fit: BoxFit.fill),
//
//                 // Image.network(document['image'], fit: BoxFit.fill),
//                 // Image.asset(
//                 //   //여기에도 파이어베잇그
//                 //   product.assetName,
//                 //   package: product.assetPackage,
//                 //   fit: BoxFit.fitWidth,
//                 // ),
//               ),
//
//
//               // Image.asset(
//               //   //여기에도 파이어베잇그
//               //   product.assetName,
//               //   package: product.assetPackage,
//               //   fit: BoxFit.fitWidth,
//               // ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       //2. 여기에 파이어베이스에서 가져온 이름을 넣기
//                       document['name'],
//                       //product.name,
//                       style: theme.textTheme.subtitle2,
//                       //style: theme.textTheme.headline6,
//                       maxLines: 1,
//                     ),
//                     const SizedBox(height: 8.0),
//                     // Text(
//                     //   document['price'],
//                     //   style: theme.textTheme.subtitle2,
//                     // )
//
//                     // TextButton( onPressed: () {
//                     //
//                     //   Navigator.push(context,
//                     //       MaterialPageRoute<void>(builder: (BuildContext context)
//                     //       {
//                     //         //ㅇㅕ기
//                     //         return pro_add(
//                     //           user: widget.user,
//                     //         );
//                     //       }
//                     //       )
//                     //   );
//                     //
//                     // }, child: Text("more"), ),
//                     // Text(
//                     //   document['description'],
//                     //   style: theme.textTheme.subtitle2,
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }
//
//
//   // TODO: Add a variable for Category (104)
//   @override
//   Widget build(BuildContext context) {
//     // TODO: Return an AsymmetricView (104)
//     // TODO: Pass Category variable to AsymmetricView (104)
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(
//             Icons.person,
//             semanticLabel: 'person',
//           ),
//           onPressed: () {
//
//             // Navigator.push(context,
//             //     MaterialPageRoute<void>(builder: (BuildContext context) {
//             //       return Profile(
//             //         user: widget.user,
//             //       );
//             //     }));
//
//
//           },
//         ),
//         title: const Text('SHRINE'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(
//               Icons.add,
//               semanticLabel: 'add',
//             ),
//             onPressed: () {
//
//               // Navigator.push(context,
//               //     MaterialPageRoute<void>(builder: (BuildContext context) {
//               //       //ㅇㅕ기
//               //       return pro_add(
//               //         user: widget.user,
//               //       );
//               //     }));
//
//
//             },
//           ),
//           // IconButton(
//           //   icon: const Icon(
//           //     Icons.tune,
//           //     semanticLabel: 'filter',
//           //   ),
//           //   onPressed: () {
//           //     print('Filter button');
//           //   },
//           // ),
//         ],
//       ),
//       // body: GridView.count(
//       //   crossAxisCount: 2,
//       //   padding: const EdgeInsets.all(16.0),
//       //   childAspectRatio: 8.0 / 9.0,
//       //   children: _buildGridCards(context),
//       // ),
//
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: database.orderBy('followers', descending: false).snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasError || !snapshot.hasData) {
//                   return Center(
//                     child: Text('Error: ${snapshot.error}'),
//                   );
//                 }
//
//                 return  GridView.count(
//                   crossAxisCount: 2,
//                   padding: const EdgeInsets.all(16.0),
//                   childAspectRatio: 8.0 / 9.0,
//                   children: _buildGridCards(context, snapshot),
//                 );
//
//                 // return ListView(
//                 //               padding: const EdgeInsets.all(16.0),
//                 //               children:
//                 //               _buildGridCards(context, snapshot) // Changed code
//                 //           );
//
//                 // switch (snapshot.connectionState) {
//                 //   case ConnectionState.waiting:
//                 //     return const Center(
//                 //       child: Text('Loading...'),
//                 //     );
//                 //   default:
//                 //     return ListView(
//                 //         padding: const EdgeInsets.all(16.0),
//                 //         children:
//                 //         _buildGridCards(context, snapshot) // Changed code
//                 //     );
//                 // }
//               },
//             ),
//           ),
//         ],
//       ),
//       resizeToAvoidBottomInset: false,
//     );
//   }
//
// }
