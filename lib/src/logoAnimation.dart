
import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../Provider/AuthProvider.dart';

class Logo extends StatefulWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 6), () {
      Navigator.pushNamed(context, '/start');

    });
    return Scaffold(
            body:Center(

            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  <Widget>[


              SizedBox(
              width: 200.0,
              child: TextLiquidFill(
                text: 'YORIJORI',
                waveColor: Color(0xFF961D36),
                boxBackgroundColor: Colors.white,

                textStyle: TextStyle(
                  fontFamily: 'Yrsa',
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
                boxHeight: 100.0,
              ),
            ),


            Lottie.asset('assets/75783-prepare-food.json'),
              ],
            ),
            ),
    );


  }
}

