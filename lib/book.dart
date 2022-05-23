import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'Provider/AuthProvider.dart';
import 'home.dart';
import 'src/ItemCard.dart';
import 'package:image_picker/image_picker.dart';
import 'hot.dart';
import 'login.dart';
import 'myProfile.dart';

class HotPage extends StatefulWidget {
  const HotPage({Key? key}) : super(key: key);

  @override
  _HotPageState createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> {
  bool _isFavorited  = true;
  int _currentIndex = 0;
  String profile = " ";
  String ids = " ";
  final List<Widget> _children = [HomesPage(), HotPage(), HomePage(), HotPage(), HomePage()];
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  String kind = "한식";
  @override
  Widget build(BuildContext context) {
    print("here is homepage");
    return Scaffold(
      appBar: AppBar(
        leading: Column(
          children: const <Widget>[

            Text('BookMark',
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
      body:StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (!snapshot.hasData) {
            return LoginPage();
          } else {
            _children[_currentIndex];
            return Center(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection('post').orderBy('like',descending: true).snapshots(),
                      builder: (context, snapshot){
                        final docum = snapshot.data!.docs;
                        int i = docum.length;
                        int count = 0;
                        /*for(int y=0;y<i;y++){
                          final data = docum[y].data();
                          String type = data['type'];
                          if(type == kind) {
                            count++;
                          }
                        }
                        print("${count}");
                         */
                        return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,),
                            itemCount: docum.length,
                            itemBuilder: (_, i){
                              final data = docum[i].data();
                              int price = data['price'];
                              String creator = data['creator'];
                              String descript = data['description'];
                              String title = data['title'];
                              String type = data['type'];
                              String file = data['image'];
                              int like = data['like'];
                              final usercol = FirebaseFirestore.instance.collection("user").doc("$creator");
                              usercol.get().then((value) => { //값을 읽으면서, 그 값을 변수로 넣는 부분
                                profile = value['image'],
                                ids = value['id'],
                              });
                              print("${ids}");
                              return Card(
                                clipBehavior: Clip.antiAlias,
                                child: Wrap(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20.0,
                                              backgroundImage: NetworkImage(
                                                  profile),
                                              backgroundColor: Colors
                                                  .transparent,
                                            ),
                                            SizedBox(width: 20,),
                                            Text(
                                              '$ids',
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '$descript',
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                    AspectRatio(
                                      aspectRatio: 25 / 11,
                                      child:
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        child: Image.network(
                                          file,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 5, 0, 0),
                                        child: Column(
                                          // TODO: Align labels to the bottom and center (103)
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          // TODO: Change innermost Column (103)
                                          children: <Widget>[
                                            /*Text(
                                              '$name',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                              maxLines: 1,
                                            ),*/
                                            // TODO: Handle overflowing labels (103)
                                            Text(
                                              '열량: ',
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                              maxLines: 1,
                                            ),
                                            Text(
                                              '가격: $price',
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                              maxLines: 1,
                                            ),
                                            Text(
                                              '재료: 양파(200g), 파(100g), 돼지고기(300g)',
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                              maxLines: 2,
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    icon:(_isFavorited
                                                        ? const Icon(Icons.favorite)
                                                        : const Icon(Icons.favorite_border)),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        if (_isFavorited) {
                                                          like -= 1;
                                                          _isFavorited = false;

                                                        } else {
                                                          like += 1;
                                                          _isFavorited = true;
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection('post')
                                                              .doc("${FieldPath.documentId}")
                                                              .update(
                                                              <String, dynamic>{
                                                                'favoritenum': like,
                                                              });
                                                        }
                                                      });
                                                    }
                                                ),
                                                Text(
                                                  '${like}',
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.chat_outlined,
                                                    semanticLabel: 'chatting',
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {

                                                  },
                                                ),

                                                IconButton(
                                                  alignment: Alignment
                                                      .centerRight,
                                                  icon: const Icon(
                                                    Icons.book_outlined,
                                                    semanticLabel: 'bookmark',
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {

                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

}