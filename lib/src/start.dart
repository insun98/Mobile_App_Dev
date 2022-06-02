import 'package:flutter/material.dart';
import 'package:shrine/src/hot.dart';
import 'package:shrine/src/myProfile.dart';
import 'package:shrine/src/home.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int selectedPage = 0;

  final _pageOptions = [
    HomesPage(),
    HotPage(),
    myProfile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _pageOptions[selectedPage],

        bottomNavigationBar: BottomNavigationBar(

          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.whatshot), label: 'Hot'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'profile'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.addchart), label: 'Ranking'),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF961D36),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: (index){
            setState(() {
              selectedPage = index;
            });
          },
        )
    );
  }
}