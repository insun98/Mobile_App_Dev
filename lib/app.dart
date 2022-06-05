// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';

import 'package:shrine/src/friendProfile.dart';
import 'package:shrine/src/logoAnimation.dart';
import 'package:shrine/src/start.dart';

import 'package:shrine/src/viewSubsribers.dart';

import 'package:shrine/src/book.dart';

import 'src/myProfile.dart';
import 'src/hot.dart';
import 'src/map.dart';
import 'ranking.dart';


 import 'src/login.dart';
import 'src/signup.dart';
 import 'src/home.dart';
// TODO: Convert ShrineApp to stateful widget (104)
class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,  // 밝기 여부
        primaryColor: Colors.black,  // 강조색
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Yras',// 앱 배경색
        appBarTheme: const AppBarTheme(
          shadowColor: Colors.white,
          backgroundColor: Colors.blue,
        ),  // 상단바 그림자, 배경색
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),  // 플로팅 버튼 배경색
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontSize: 42,
            fontWeight: FontWeight.bold,
              fontFamily: 'Yras'
          ),
          headline2: TextStyle(
            color: Colors.black87,
            fontSize: 28,
            fontFamily: 'Yras'
          ),
          bodyText1: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      title: 'YoriJori',
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        '/signup': (BuildContext context) => const SignupPage(),
        '/': (BuildContext context) => const HomesPage(),
       '/hot': (BuildContext context) => const HotPage(),
        '/profile': (BuildContext context) => const myProfile(),
        '/book': (BuildContext context) => const BookPage(),
        '/start': (BuildContext context) => StartPage(),

      '/rank': (BuildContext context) => const rankPage(),
        '/editProfile': (BuildContext context) => const editProfile(),
        '/viewSubscribers': (BuildContext context) => const viewSubscribers(),

        '/map':(BuildContext context) => const MyMap(),
      


        '/postDetail': (BuildContext context) => const PostDetail(),
    '/logo': (BuildContext context) => const Logo(),

      },

    );
  }
}

