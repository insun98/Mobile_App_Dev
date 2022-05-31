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

class viewSubscribers extends StatefulWidget {
  const viewSubscribers({Key? key}) : super(key: key);

  @override
  _viewSubscribersState createState() => _viewSubscribersState();
}

class _viewSubscribersState extends State<viewSubscribers> {
  Widget build(BuildContext context) {
    ApplicationState authProvider = Provider.of<ApplicationState>(context);
    PostProvider postProvider = Provider.of<PostProvider>(context);

    return Scaffold(


      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: TextButton(
            style: TextButton.styleFrom(),
            child: const Text('Yori \n Jori',
                style: TextStyle(color: Color(0xFF961D36), fontFamily: 'Yrsa')),
            onPressed: () {}),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.grey,
                semanticLabel: 'filter',
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, ProfileProvider, _) => Column(

         children:[
           Container(
             padding:EdgeInsets.all(10),
             decoration: const BoxDecoration(
               color: Color(0xFF961D36),
             ),
           child: Row(children:const [ Text('Subsribing', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)],),),
      SizedBox(
        height:500,
           child:ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: ProfileProvider.subscribingProfile.length,

        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed:(direction) {

            },
            child: SizedBox(
              height: 50,
              child: Row(children:[
                Image.network(ProfileProvider.subscribingProfile[index].photo, width: 50, height: 50,),
                TextButton(
                  onPressed: ()  async {
                    bool isSubscribed = await ProfileProvider.getUser(ProfileProvider.subscribingProfile[index].uid);
                    await postProvider.getPost(ProfileProvider.subscribingProfile[index].uid);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => friendProfile(isSubscribed: isSubscribed)));

                  },
                  child: Text(
                    "${ProfileProvider.subscribingProfile[index].id} ",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),



              ],

              ),
            ),
          );
        },
        separatorBuilder:
            (BuildContext context, int index) {
          return const Divider(color: Colors.grey,);
        },
      ), ),], ),
        ),

    );
  }
}
