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
//import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';

import 'Provider/AuthProvider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ApplicationState authProvider= Provider.of<ApplicationState>(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 120.0),
            Column(
              children: const <Widget>[
                Text('Yori',
                    style: TextStyle(
                        fontFamily: 'Yrsa',
                        color: Color(0xFF961D36),
                        fontSize: 64)),
                Text('Jori',
                    style: TextStyle(
                        fontFamily: 'Yrsa',
                        color: Color(0xFF961D36),
                        fontSize: 64)),
              ],
            ),
            const SizedBox(height: 30.0),
            // TODO: Remove filled: true values (103)
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFFBF7F7),
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFFBF7F7),
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: const Text('로그인'),
              style: ElevatedButton.styleFrom(primary: Color(0xFF961D36)),
              onPressed: () async {
                bool? login = await authProvider.verifyEmail(_usernameController.text, (e) => _showErrorDialog(context, 'Invalid email', e));

                if(login == true){
                  print(_passwordController);
                  authProvider.signInWithEmailAndPassword(_usernameController.text, _passwordController.text,(e) => _showErrorDialog(context, 'Invalid email', e));
                  Navigator.pushNamed(context, '/');
                }else{
                  print("false");
                }
                _usernameController.clear();
                _passwordController.clear();
              },
            ),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {Navigator.pushNamed(context, '/signup');},
                  child: Text('회원가입'),
                  style: TextButton.styleFrom(primary: Color(0xFF7B7877)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }
}

