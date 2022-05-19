import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'Provider/AuthProvider.dart';
import 'src/ItemCard.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  File? _image;
  @override
  Widget build(BuildContext context) {
    print("here is mypage");
    return Scaffold(
      appBar: AppBar(
        leading: Column(
          children: const <Widget>[

            Text('Yori',
                style: TextStyle(
                    fontFamily: 'Yrsa',
                    color: Color(0xFF961D36),
                    fontSize: 23)),
            Text('Jori',
                style: TextStyle(
                    fontFamily: 'Yrsa',
                    color: Color(0xFF961D36),
                    fontSize: 23)),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.menu,
              semanticLabel: 'logout',
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
        title: Container(width: 0,),
      ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF961D36),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          currentIndex: _selectedIndex,
          //현재 선택된 Index
          onTap: (int index) {
            switch (index) {
              case 1:
                Navigator.pushNamed(context, '/');
                break;
              case 2:
                Navigator.pushNamed(context, '/');
                break;
              default:
            }
          },

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.whatshot), label: 'Hot'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'profile'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.addchart), label: 'Ranking'),
          ],
        ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          final docum = snapshot.data!.docs;
          for (int y = 0; y < docum.length; y++) {
            final datay = docum[y].data();
            String email = datay['email'];
            String followers = datay['followers'];
            String id = datay['id'];
            String image = '${datay['image']}';
            String name = datay['name'];
            String uid = datay['uid'];
            return Expanded(
                child: ListView(

                ),
            );
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}