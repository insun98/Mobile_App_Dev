
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

class rankPage extends StatefulWidget {
  const rankPage({Key? key}) : super(key: key);

  @override
  _rankPageState createState() => _rankPageState();
}


// let len = 0
// const ref = firebase.firestore().collection("users").doc(user.uid).get().then(snap => {
// len = snap.data().disliked1.length
// console.log(len)
// })


class _rankPageState extends State<rankPage> {
  var i = 0;

  List<InkWell> _buildListCards(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    final ThemeData theme = Theme.of(context);
    i=0;
    return snapshot.data!.docs.map((DocumentSnapshot document) {
      i++;

      //DateTime _dateTime =
      //DateTime.parse(document['expirationDate'].toDate().toString());
      return
        InkWell(


          onTap: () {
            // dialog(document['photoUrl'], document['productName'], _dateTime,
            //     document['description']);
          },
          child: Column (
              children: [

                Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Row(
                      children: [
                        Text( i.toString(),  style: theme.textTheme.headline6,
                        ),
                        SizedBox(width: 20,),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipOval(
                            child:
                            Image.network(document['image'], fit: BoxFit.fill),
                          ),
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
                              Text(
                                document['email'],
                                style: theme.textTheme.subtitle2,
                              ),
                              // Text(
                              //   "Followers: "+document['followers'].toString(),
                              //   style: theme.textTheme.subtitle2,
                              // ),
                            ],
                          ),
                        ),

                      ],
                    )

                ),

                Divider(height: 10,color: Colors.black,),



              ])


      );
    }).toList();
  }




  @override
  Widget build(BuildContext context) {
    // print("here is homepage");
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (!snapshot.hasData) {
            return LoginPage();
          } else {




            return Column(

              children: <Widget>[
                Container(
                  padding:EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF961D36),
                  ),
                  child: Row(children:const [ Text('Ranking', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)],),),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(

                    // /subscriber.length
                    //  stream: FirebaseFirestore.instance.collection('user').orderBy('email', descending: true).limit(3).snapshots(),
                    //stream: FirebaseFirestore.instance.collection('user').orderBy('email', descending: true).limit(3).snapshots(),

                    stream: FirebaseFirestore.instance.collection('user').orderBy('followers', descending: true).limit(3).snapshots(),

                    //stream: FirebaseFirestore.instance.collection('followers').snapshots(),
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
                            child: Text('Loading…'),
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
            );
            //  );
          }
        },

    );
  }

}


