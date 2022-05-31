import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:shrine/src/HomeCard.dart';

import 'package:shrine/search.dart';

import 'dart:io';

import '../Provider/AuthProvider.dart';
import '../Provider/PostProvider.dart';
import '../Provider/ProfileProvider.dart';
import 'home.dart';
import '../src/ItemCard.dart';
import 'package:image_picker/image_picker.dart';
import 'hot.dart';
import '../src/login.dart';
import '../src/myProfile.dart';

class HotPage extends StatefulWidget {
  const HotPage({Key? key}) : super(key: key);

  @override
  _HotPageState createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> {
  bool _isFavorited  = true;
  int _selectedIndex = 1;
  String profile = " ";
  String ids = " ";




  //String kind = "한식";
  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    print("here is hotpage");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: TextButton(
            style: TextButton.styleFrom(),
            child: Text('Hot',
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

      body:Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            homeCard(
              posts: postProvider.allPosts,
              profiles: profileProvider.allUsers,
            ),
          ],

        ),
      ),
    );
  }

}