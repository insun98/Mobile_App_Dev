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
  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<PostProvider>(
          builder: (context, postProvider, _) => homeCard(
            posts: postProvider.allPosts,
            profiles: profileProvider.allUsers,
          ),
        ),
      ],
    );
  }
}
