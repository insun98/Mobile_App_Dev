
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shrine/search.dart';
import 'dart:io';
import 'Provider/AuthProvider.dart';
import 'src/home.dart';
import 'src/ItemCard.dart';
import 'package:image_picker/image_picker.dart';
import 'src/hot.dart';
import 'src/login.dart';
import 'src/myProfile.dart';
import 'package:adaptive_theme/adaptive_theme.dart';



import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../src/addPost.dart';
import '../src/ItemCard.dart';
import '../src/friendProfile.dart';
import '../Provider/AuthProvider.dart';
import '../Provider/ProfileProvider.dart';
import '../Provider/PostProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class rankPage extends StatefulWidget {
  const rankPage({Key? key}) : super(key: key);

  @override
  _rankPageState createState() => _rankPageState();
}

class _rankPageState extends State<rankPage> {
  Widget build(BuildContext context) {
    ApplicationState authProvider = Provider.of<ApplicationState>(context);
    PostProvider postProvider = Provider.of<PostProvider>(context);

    return
    Container(
      child:Consumer<ProfileProvider>(
        builder: (context, ProfileProvider, _) => Column(

          children:[
           // Container(
              // padding:EdgeInsets.all(10),
              // decoration: const BoxDecoration(
              //   color: Color(0xFF961D36),
              // ),
              // child: Row(children:const [ Text('구독', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)],),),
            // SizedBox(
            //   height:700,
              Container(
                padding:EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF961D36),
                ),
                child: Row(children:const [ Text('Ranking', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)],),),
              Expanded(
              child:ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: ProfileProvider.rankUsers.length,

                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed:(direction) {

                    },
                    child:  Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      //height: 50,
                      child: Row(
                        children:[
                          RichText(text:
                          TextSpan(
                          text:  (index+1).toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          )
                      ),
                          ),
                      SizedBox(width:10),
                         // Text( (index+1).toString(),  style:theme.headline6,),
                      SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipOval(
                            child:
                            Image.network(ProfileProvider.rankUsers[index].photo, fit: BoxFit.fill),
                          ),
                        ),

                      //  Image.network(ProfileProvider.rankUsers[index].photo, width: 50, height: 50,),
                        SizedBox(
                          width: 174,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          const SizedBox(
                          height: 10,
                          ),
                          Row(
                            children:[
                              SizedBox(width:10),
                              TextButton(
                   onPressed: ()  async {
                      bool isSubscribed = await ProfileProvider.getUser(ProfileProvider.rankUsers[index].uid);
                      await postProvider.getPost(ProfileProvider.rankUsers[index].uid);
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => friendProfile(isSubscribed: isSubscribed)));
                    },
                  child:
                  // Text(
                  //     "${ProfileProvider.rankUsers[index].id} ",
                  //     style: const TextStyle(color: Colors.black,),
                  //
                  //     ),
                  RichText(text:
                  TextSpan(
                  text:  "${ProfileProvider.rankUsers[index].id} ",
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                  )
                  ),
                  ),

                  ),

                           ]
                        ),
                  SizedBox(height: 5.0),
                  Text(
                          "     전문분야 : ${ProfileProvider.rankUsers[index].profession} ",
                          style: const TextStyle(color: Colors.black,
                                                fontWeight: FontWeight.bold
                          ),
                        ),
                  Text(
                    "     구독자 : ${ProfileProvider.rankUsers[index].subscribers.length} ",
                    style: const TextStyle(color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                      ],

                      ),
                    ),
                  ],
                  ),
                    ),
                  );
                },

                // itemBuilder: (BuildContext context, int index) {
                //   return Dismissible(
                //     key: UniqueKey(),
                //     onDismissed:(direction) {
                //
                //     },
                //     child: SizedBox(
                //       height: 50,
                //       child: Row(children:[
                //         Image.network(ProfileProvider.subscribingProfile[index].photo, width: 50, height: 50,),
                //         TextButton(
                //           onPressed: ()  async {
                //             bool isSubscribed = await ProfileProvider.getUser(ProfileProvider.subscribingProfile[index].uid);
                //             await postProvider.getPost(ProfileProvider.subscribingProfile[index].uid);
                //              Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => friendProfile(isSubscribed: isSubscribed)));
                //           },
                //           child: Text(
                //             "${ProfileProvider.subscribingProfile[index].id} ",
                //             style: const TextStyle(color: Colors.black),
                //           ),
                //         ),
                //
                //
                //
                //       ],
                //
                //       ),
                //     ),
                //   );
                // },
                separatorBuilder:
                    (BuildContext context, int index) {
                  return const Divider(color: Colors.grey,thickness: 1.0);
                },
              ), ),], ),
      ),

    );
  }
}






// class rankPage extends StatefulWidget {
//   const rankPage({Key? key}) : super(key: key);
//
//   @override
//   _rankPageState createState() => _rankPageState();
// }


// let len = 0
// const ref = firebase.firestore().collection("users").doc(user.uid).get().then(snap => {
// len = snap.data().disliked1.length
// console.log(len)
// })

//
// class _rankPageState extends State<rankPage> {
//   var i = 0;
//
//   List<InkWell> _buildListCards(
//       BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     final ThemeData theme = Theme.of(context);
//     i=0;
//     return snapshot.data!.docs.map((DocumentSnapshot document) {
//       i++;
//
//       //DateTime _dateTime =
//       //DateTime.parse(document['expirationDate'].toDate().toString());
//       return
//         InkWell(
//
//
//           onTap: () {
//             // dialog(document['photoUrl'], document['productName'], _dateTime,
//             //     document['description']);
//           },
//           child: Column (
//               children: [
//                // Divider(height: 10,color: Color(0xFF961D36),),
//
//                 Container(
//                     margin: const EdgeInsets.only(bottom: 25),
//                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                     decoration: const BoxDecoration(
//                       color: Colors.white24,
//                       borderRadius: BorderRadius.all(Radius.circular(15)),
//                     ),
//                     child: Row(
//                       children: [
//                         Text( i.toString(),  style: theme.textTheme.headline6,
//                         ),
//                         SizedBox(width: 20,),
//                         SizedBox(
//                           width: 80,
//                           height: 80,
//                           child: ClipOval(
//                             child:
//                             Image.network(document['image'], fit: BoxFit.fill),
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 30,
//                         ),
//                         SizedBox(
//                           width: 174,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               Row(
//                                 children: [
//                                   IconButton(onPressed: (){
//
//                                   }, icon: Icon(Icons.search), ),
//                                   // TextButton(onPressed:  (){}, child: Icon(Icons.search),
//                                   //   style: TextButton.styleFrom( // 스타일 폼에서 작성할 수 있음
//                                   //       primary: Color(0xFF961D36), // 텍스트 색 바꾸기
//                                   //       backgroundColor: Colors.blue), // 백그라운드로 컬러 설정
//                                   // ),
//                                   Text(
//                                   document['name'],
//                                   style: theme.textTheme.headline6,
//                                   maxLines: 1,
//                                 ),
//                                   // SizedBox(width: 3.0),
//                                   // ElevatedButton(
//                                   //   child: Icon(Icons.search),
//                                   //   style: ElevatedButton.styleFrom(primary: Color(0xFF961D36),),
//                                   //
//                                   //   onPressed: () async {
//                                   //   },
//                                   // ),
//                                   // IconButton(onPressed: (){}, icon: Icon(Icons.search), ),
//                                   // TextButton(onPressed:  (){}, child: Icon(Icons.search),
//                                   //   style: TextButton.styleFrom( // 스타일 폼에서 작성할 수 있음
//                                   //       primary: Color(0xFF961D36), // 텍스트 색 바꾸기
//                                   //       backgroundColor: Colors.blue), // 백그라운드로 컬러 설정
//                                   // ),
//                                 ],
//                               ),
//
//                                SizedBox(height: 8.0),
//                               Text(
//                                 document['email'],
//                                 style: theme.textTheme.subtitle2,
//                               ),
//                               // Text(
//                               //   "Followers: "+document['followers'].toString(),
//                               //   style: theme.textTheme.subtitle2,
//                               // ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     )
//
//                 ),
//
//                 Divider(height: 10,color: Colors.grey,thickness: 1.0,
//                 ),
//
//
//
//               ]
//
//           )
//
//
//       );
//     }).toList();
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // print("here is homepage");
//     return StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
//           if (!snapshot.hasData) {
//             return LoginPage();
//           } else {
//
//
//
//
//             return Column(
//
//               children: <Widget>[
//                 Container(
//                   padding:EdgeInsets.all(10),
//                   decoration: const BoxDecoration(
//                     color: Color(0xFF961D36),
//                   ),
//                   child: Row(children:const [ Text('Ranking', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)],),),
//                 Expanded(
//                   child: StreamBuilder<QuerySnapshot>(
//
//                     // /subscriber.length
//                     //  stream: FirebaseFirestore.instance.collection('user').orderBy('email', descending: true).limit(3).snapshots(),
//                     //stream: FirebaseFirestore.instance.collection('user').orderBy('email', descending: true).limit(3).snapshots(),
//
//                     stream: FirebaseFirestore.instance.collection('user').orderBy('followers', descending: true).limit(3).snapshots(),
//
//                     //stream: FirebaseFirestore.instance.collection('followers').snapshots(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<QuerySnapshot> snapshot) {
//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text('Error: ${snapshot.error}'),
//                         );
//                       }
//                       switch (snapshot.connectionState) {
//                         case ConnectionState.waiting:
//                           return const Center(
//                             child: Text('Loading…'),
//                           );
//                         default:
//                           return ListView(
//                               padding: const EdgeInsets.all(16.0),
//                               children:
//                               _buildListCards(context, snapshot) // Changed code
//                           );
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             );
//             //  );
//           }
//         },
//
//     );
//   }
//
// }
