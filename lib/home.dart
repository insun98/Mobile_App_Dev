
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shrine/src/HomeCard.dart';
import 'dart:io';
import 'Provider/AuthProvider.dart';
import 'src/ItemCard.dart';
import 'package:image_picker/image_picker.dart';
import 'hot.dart';
import 'src/login.dart';
import 'src/myProfile.dart';

class HomesPage extends StatefulWidget {
  const HomesPage({Key? key}) : super(key: key);

  @override
  _HomesPageState createState() => _HomesPageState();
}

class _HomesPageState extends State<HomesPage> {
  int _currentIndex = 0;
  //String profile = " ";
 // String ids = " ";
  bool _isFavorited  = false;
  final List<Widget> _children = [HomesPage(), HotPage(),];
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  String kind = "한식";
  @override
  Widget build(BuildContext context) {
    ApplicationState postProvider = Provider.of<ApplicationState>(context);
    print("here is homepage");
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
              Icons.account_circle_outlined,
              semanticLabel: 'mypage',
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/mypage');
            },
          ),
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
          currentIndex: _currentIndex,
          onTap: _onTap,
          //현재 선택된 Index

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.whatshot), label: 'Hot'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'profile'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.addchart), label: 'Ranking'),
          ],
        ),
      body:Consumer<ApplicationState>(
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
              posts: postProvider.MyPosts,
              profile: postProvider.profile,
            ),
          ],

        ),
      ),
    );
  }

}
