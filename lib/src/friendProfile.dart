import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'package:provider/provider.dart';
import 'package:shrine/Provider/MessageProvider.dart';
import 'dart:io';
import '../src/addPost.dart';
import '../src/ItemCard.dart';

import '../Provider/AuthProvider.dart';
import '../Provider/ProfileProvider.dart';
import '../Provider/PostProvider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/cupertino.dart';
class friendProfile extends StatefulWidget {
  friendProfile({required this.isSubscribed});
  bool isSubscribed;
  @override
  _friendProfileState createState() => _friendProfileState();
}

class _friendProfileState extends State<friendProfile> {

  File? _image;
  String dropdownValue = '인기순';
  List<String>prediction =[];
  bool textScanning= false;
  Widget build(BuildContext context) {
    MessageProvider messageProvider= Provider.of<MessageProvider>(context);
    PostProvider postProvider= Provider.of<PostProvider>(context);

    return Consumer<ProfileProvider>(
      builder: (context, ProfileProvider, _) =>Scaffold(
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
                  Icons.add,
                  color: Colors.grey,
                  semanticLabel: 'filter',
                ),
                onPressed: () async{

                  bool check = await getImageFromGallery(ImageSource.gallery);

                  if(check==true){
                    Navigator.push(context,  MaterialPageRoute(builder: (context) => addPostPage(image: _image, prediction: prediction,)));
                  }}) ,
            Builder(
              builder: (context) => IconButton(
                color: Colors.black,
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const Padding(
                child: Text('Yori  Jori',
                    style: TextStyle(color: Color(0xFF961D36), fontFamily: 'Yrsa',fontSize: 30)),
                padding: EdgeInsets.only(top: 40, left: 10),
              ),
              const Divider(),

              ListTile(
                leading: const Icon(
                  Icons.people,
                  color: Color(0xFF961D36),
                ),
                title: const Text(
                  'Subscribers',
                  style: TextStyle(color: Color(0xFF961D36)),
                ),
                onTap: ()  async {

                  Navigator.pushNamed(context, '/viewSubscribers');
                },

              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_filter_outlined,
                  color: Colors.black,
                ),
                title: const Text('Posts'),
                onTap: () {
                  // Navigator.pushNamed(context, '/friendlist');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Color(0xFF961D36),
                ),
                title: const Text('Settings'),
                onTap: () {},
              ),


            ],
          ),
        ),

        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(ProfileProvider.otherProfile.photo),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 20.0),
                  Text(ProfileProvider.otherProfile.id, style: TextStyle(fontSize: 20, color: Colors.black)),
                  const SizedBox(height: 10.0),
                  Text(ProfileProvider.otherProfile.name,
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                  const SizedBox(height: 10.0),
                  Text('Subscribers:${ProfileProvider.otherProfile.subscribers.length}',
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.isSubscribed == true? ElevatedButton(
                        child: const Text('구독중', style: TextStyle(color: Color(0xFF961D35)),),
                        style: ElevatedButton.styleFrom(primary: Color(0xFFFBF7F7)),
                        onPressed: () async {ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('이미 구독중입니다.'),
                        ));},
                      ):ElevatedButton(
                        child: const Text('구독하기'),
                        style: ElevatedButton.styleFrom(primary: Color(0xFF961D35)),
                        onPressed: () async {ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('구독을 시작합니다.'),
                        ));
                          ProfileProvider.addSubscriber(ProfileProvider.otherProfile.uid);
                          },
                      ),
                      ElevatedButton(
                        child: const Text('대화하기'),
                        style: ElevatedButton.styleFrom(primary: Color(0xFF961D35)),
                        onPressed: () async {
                          await messageProvider.getMessages(ProfileProvider.otherProfile.uid);
                          Navigator.pushNamed(context, '/chat');
                        },
                      ),

                    ],

                  ),
                ],
              ),
            ),
            Container(margin: EdgeInsets.only(left:35), child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down_outlined),
              elevation: 0,

              style: const TextStyle(color: Colors.black),
              items: dropdownItems,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  postProvider.getTimePost(dropdownValue);
                });
              },
            ),),
            itemCard(myPost: postProvider.frinedPost,),
          ],

        ),
      ),


    );

  }
  Future<bool> getImageFromGallery(ImageSource imageSource)  async{
    var image = await ImagePicker.platform
        .pickImage(source: imageSource, maxWidth: 650, maxHeight: 100);
    setState(() {
      _image= File(image!.path);
      print("good");
    });
    if(image != null){
      print("good");
      textScanning =true;
      setState(() {});
      getRecognisedText1(_image!);
      return true;
    }else {
      return false;
    }

  }
  void getRecognisedText1 (File image) async{
    ImageLabelerOptions option = ImageLabelerOptions();
    final inputImage =InputImage.fromFilePath(image.path);
    print("success1");
    final ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.5);
    print("success2");

    final imageLabeler = GoogleMlKit.vision.imageLabeler();
    print("success3");
    final List<ImageLabel> imagelabel = await imageLabeler.processImage(inputImage);
    print("success3");
    prediction = [];
    for(ImageLabel one in imagelabel){
      print("success");
      prediction.add(one.label);
    }
    textScanning = false;
    setState(() {});
  }
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("인기순"),value: "인기순"),
      DropdownMenuItem(child: Text("가장 오래된 순"),value: "가장 오래된 순"),
      DropdownMenuItem(child: Text("최신순"),value: "최신순"),

    ];
    return menuItems;
  }
}

