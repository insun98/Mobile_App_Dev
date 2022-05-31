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
class myProfile extends StatefulWidget {
  const myProfile({Key? key}) : super(key: key);

  @override
  _myProfileState createState() => _myProfileState();
}

class _myProfileState extends State<myProfile> {
  int _selectedIndex = 2;
  File? _image;
  String dropdownValue = '인기순';
  Widget build(BuildContext context) {
    ApplicationState authProvider= Provider.of<ApplicationState>(context);
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
            child: Text('Yori \n Jori',
                style: TextStyle(color: Color(0xFF961D36), fontFamily: 'Yrsa')),
            onPressed: () {}),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.grey,
                semanticLabel: 'filter',
              ),
              onPressed: () async{

                bool check = await getImageFromGallery(ImageSource.gallery);

                if(check==true){
               Navigator.push(context,  MaterialPageRoute(builder: (context) => addPostPage(image: _image)));
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
                backgroundImage: NetworkImage(ProfileProvider.myProfile.photo),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(height: 20.0),
              Text(ProfileProvider.myProfile.id, style: TextStyle(fontSize: 20, color: Colors.black)),
              const SizedBox(height: 10.0),
              Text(ProfileProvider.myProfile.name,
                  style: TextStyle(fontSize: 15, color: Colors.black)),
              const SizedBox(height: 10.0),
              Text('Subscribers:${ProfileProvider.myProfile.subscribers.length}',
                  style: TextStyle(fontSize: 15, color: Colors.black)),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text('프로필 수정'),
                    style: ElevatedButton.styleFrom(primary: Color(0xFF961D36)),
                    onPressed: () async {Navigator.pushNamed(context, '/editProfile');},
                  ),
                  SizedBox(width:30),
                  ElevatedButton(
                    child: const Text('로그아웃'),
                    style: ElevatedButton.styleFrom(primary: Color(0xFF961D36)),
                    onPressed: () async {authProvider.signOut();Navigator.pushNamed(context, '/login');},
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
        itemCard(myPost: postProvider.myPost,),
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
    });
    if(image != null){
      return true;
    }else {
        return false;
    }

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

class editProfile extends StatefulWidget {
  const editProfile({Key? key}) : super(key: key);

  @override
  _editProfileState createState() => _editProfileState();
}


class _editProfileState extends State<editProfile> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _professionController = TextEditingController();

  File? _image;
  @override
  Widget build(BuildContext context) {
    PostProvider postProvider= Provider.of<PostProvider>(context);
    ProfileProvider profileProvider= Provider.of<ProfileProvider>(context);
     FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.data() != null) {
          _nameController.text = snapshot.data()!['name'];
          _idController.text= snapshot.data()!['id'];
          _professionController.text = snapshot.data()!['profession'];

        }
      });

    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: const Text('프로필 수정', style: TextStyle(color:Colors.black),),
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
              String URL = await postProvider.UploadFile(_image!);



                await profileProvider.editProfile(URL, _nameController.text,
                    _idController.text,  _professionController.text);


              Navigator.pop(context);

              Navigator.pop(context);
            },
            style: TextButton.styleFrom(primary: Colors.black),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(

      builder: (context, ProfileProvider, _) =>SingleChildScrollView(
        child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[

          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: _image == null?Image.network(
               ProfileProvider.myProfile.photo,
              height: 150.0,
              width: 150.0,
            ):Image.file(File(_image!.path), height: 150.0,
                width: 150.0,fit:BoxFit.fill),
          ),
          ElevatedButton(
            child: const Text('수정'),
            style: ElevatedButton.styleFrom(primary: Color(0xFF961D36)),
            onPressed: () async {
              bool check = await getImageFromGallery(ImageSource.gallery);



            },
          ),
          Container
            (padding: EdgeInsets.all(20),
            child:Column (children:[
          TextField(
            controller: _nameController,

            decoration: const InputDecoration(

              filled: false,
              fillColor: Color(0xFFFBF7F7),
              labelText: '이름',

            ),

          ),
          const SizedBox(height: 12.0),
          TextField(

            controller: _idController,
            decoration: const InputDecoration(
              filled: false,
              fillColor: Color(0xFFFBF7F7),
              labelText: '아이디',

            ),

          ),

          const SizedBox(height: 12.0),
          TextField(
            controller: _professionController,
            decoration: const InputDecoration(
              filled: false,
              fillColor: Color(0xFFFBF7F7),
              labelText: '전문분야',

            ),
          ),
        ],
          ),
          ),

        ],
        ),
      ),
      ),
    );
  }
  Future<bool> getImageFromGallery(ImageSource imageSource)  async{
    var image = await ImagePicker.platform
        .pickImage(source: imageSource, maxWidth: 650, maxHeight: 100);
    setState(() {
      _image= File(image!.path);
    });
    if(image != null){
      return true;
    }else {
      return false;
    }

  }
  }


