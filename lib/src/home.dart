
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shrine/src/HomeCard.dart';

import 'package:shrine/search.dart';
import 'dart:io';
import '../Provider/PostProvider.dart';
import '../Provider/ProfileProvider.dart';
import '../src/ItemCard.dart';
import 'package:image_picker/image_picker.dart';
import '../src/hot.dart';
import '../src/login.dart';
import '../src/myProfile.dart';

class HomesPage extends StatefulWidget {
  const HomesPage({Key? key}) : super(key: key);

  @override
  _HomesPageState createState() => _HomesPageState();
}

class _HomesPageState extends State<HomesPage> {

  int _selectedIndex = 0;
  //String profile = " ";
  // String ids = " ";
  bool _isFavorited  = false;



  final List<Widget> _children = [HomesPage(), HotPage(), HomesPage(),  HomesPage()];

  String kind = "한식";
  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    print("here is homepage");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: TextButton(
            style: TextButton.styleFrom(),
            child: Text('Yori \n Jori',
                style: TextStyle(color: Color(0xFF961D36), fontFamily: 'Yrsa')),
            onPressed: () {}),
        actions: <Widget>[

          Builder(
            builder: (context) => IconButton(
              color: Colors.black,
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),

      body:Consumer<PostProvider>(
        builder: (context, appState, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF961D36),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(
                      '양식',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState((){
                        kind = "양식";
                        postProvider.getTypePost(kind);
                      });
                    },
                  ),
                  TextButton(
                    child: Text(
                      '한식',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState((){
                        kind = "한식";
                        postProvider.getTypePost(kind);
                      });
                    },
                  ),
                  TextButton(
                    child: Text(
                      '중식',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState((){
                        kind = "중식";
                        postProvider.getTypePost(kind);
                      });
                    },
                  ),
                  TextButton(
                    child: Text(
                      '일식',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState((){
                        kind = "일식";
                        postProvider.getTypePost(kind);
                      });
                    },
                  ),
                ],
              ),
            ),
            homeCard(
              posts: postProvider.typePosts,
              profiles: profileProvider.allUsers,
            ),
          ],

        ),
      ),
    );
  }

}