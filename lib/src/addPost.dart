import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../src/ItemCard.dart';
import '../src/friendProfile.dart';
import '../Provider/AuthProvider.dart';
import '../Provider/ProfileProvider.dart';
import '../Provider/PostProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class addPostPage extends StatefulWidget {

  final File? image;
  const addPostPage({required this.image});
  @override
  _addPostPageState createState() => _addPostPageState();
}

class _addPostPageState extends State<addPostPage> {
  @override
  final _formKey = GlobalKey<FormState>(debugLabel: '_addItemPageState');
  final _controller = TextEditingController();
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  bool order =true;


  String dropdownValue = '한식';
  @override
  Widget build(BuildContext context) {
    PostProvider postProvider= Provider.of<PostProvider>(context);



    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: const Text('업로드', style: TextStyle(color:Colors.black),),
        leading:TextButton(
          child: const Text('cancel',style: TextStyle(fontSize: 12),),
          onPressed: () async {


            Navigator.pop(context);
          },
          style: TextButton.styleFrom(primary: Colors.black),
        ),


        actions: <Widget>[
          TextButton(
            child: const Text('Save'),
            onPressed: () async {
              String URL;
              URL = await postProvider.UploadFile(widget.image!);


              if (_formKey.currentState!.validate()) {
                await postProvider.addPost(URL, dropdownValue,_controller.text,
                    int.parse(_controller1.text), _controller2.text);
                _controller.clear();
                _controller1.clear();
                _controller2.clear();
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(primary: Colors.black),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.file(File(widget.image!.path),height: 200, width:500,fit:BoxFit.fill),
            Container(

              margin: EdgeInsets.all(10),
              child:Row(

                children:[



                  Expanded(child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '음식이름',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your Price to continue';
                      }
                      return null;
                    },
                  ),),
                  const SizedBox(width: 40.0),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    elevation: 0,

                    style: const TextStyle(color: Colors.black),
                    items: dropdownItems,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(width: 20.0),

                ],

              ),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _controller1,
              decoration: const InputDecoration(
                hintText: '가격대',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your Price to continue';
                }
                return null;
              },
            ),

            const SizedBox(height: 40.0),
            TextFormField(
              controller: _controller2,
              decoration: const InputDecoration(
                hintText: '설명',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your Description to continue';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("한식"),value: "한식"),
      DropdownMenuItem(child: Text("양식"),value: "양식"),
      DropdownMenuItem(child: Text("중식"),value: "중식"),
      DropdownMenuItem(child: Text("일식"),value: "일식"),
    ];
    return menuItems;
  }
}