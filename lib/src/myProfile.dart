import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../src/ItemCard.dart';
import '../Provider/AuthProvider.dart';
import '../Provider/ProfileProvider.dart';
import '../Provider/PostProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class myProfile extends StatefulWidget {
  const myProfile({Key? key}) : super(key: key);

  @override
  _myProfileState createState() => _myProfileState();
}

class _myProfileState extends State<myProfile> {
  File? _image;
  String dropdownValue = '인기순';
  Widget build(BuildContext context) {
    ApplicationState authProvider = Provider.of<ApplicationState>(context);
    PostProvider postProvider = Provider.of<PostProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<ProfileProvider>(
          builder: (context, ProfileProvider, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage:
                      NetworkImage(ProfileProvider.myProfile.photo),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 20.0),
                Text(ProfileProvider.myProfile.id,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                const SizedBox(height: 10.0),
                Text(ProfileProvider.myProfile.name,
                    style: const TextStyle(fontSize: 15, color: Colors.black)),
                const SizedBox(height: 10.0),
                Text(
                    '구독자:${ProfileProvider.myProfile.subscribers.length}',
                    style: const TextStyle(fontSize: 15, color: Colors.black)),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text('프로필 수정'),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF961D36)),
                      onPressed: () async {
                        Navigator.pushNamed(context, '/editProfile');
                      },
                    ),
                    SizedBox(width: 30),
                    ElevatedButton(
                      child: const Text('알람설정'),
                      style:
                      ElevatedButton.styleFrom(primary: Color(0xFF961D36)),
                      onPressed: () async {
                        Navigator.pushNamed(context, '/alarm');
                      },
                    ),
                    SizedBox(width: 30),
                    ElevatedButton(
                      child: const Text('로그아웃'),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF961D36)),
                      onPressed: () async {
                        authProvider.signOut();
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 35),
          child: DropdownButton<String>(
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
          ),
        ),
        Consumer<PostProvider>(
          builder: (context, postProvider, _) => itemCard(
            myPost: postProvider.myPost,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("인기순"), value: "인기순"),
      DropdownMenuItem(child: Text("가장 오래된 순"), value: "가장 오래된 순"),
      DropdownMenuItem(child: Text("최신순"), value: "최신순"),
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
    PostProvider postProvider = Provider.of<PostProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() != null) {
        _nameController.text = snapshot.data()!['name'];
        _idController.text = snapshot.data()!['id'];
        _professionController.text = snapshot.data()!['profession'];
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: const Text(
          '프로필 수정',
          style: TextStyle(color: Colors.black),
        ),
        leading: TextButton(
          child: const Text(
            'cancel',
            style: TextStyle(fontSize: 12),
          ),
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
                  _idController.text, _professionController.text);

              Navigator.pop(context);

              Navigator.pop(context);
            },
            style: TextButton.styleFrom(primary: Colors.black),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, ProfileProvider, _) => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: _image == null
                    ? Image.network(
                        ProfileProvider.myProfile.photo,
                        height: 150.0,
                        width: 150.0,
                      )
                    : Image.file(File(_image!.path),
                        height: 150.0, width: 150.0, fit: BoxFit.fill),
              ),
              ElevatedButton(
                child: const Text('수정'),
                style: ElevatedButton.styleFrom(primary: Color(0xFF961D36)),
                onPressed: () async {
                  bool check = await getImageFromGallery(ImageSource.gallery);
                },
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
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

  Future<bool> getImageFromGallery(ImageSource imageSource) async {
    var image = await ImagePicker.platform
        .pickImage(source: imageSource, maxWidth: 650, maxHeight: 100);
    setState(() {
      _image = File(image!.path);
    });
    if (image != null) {
      return true;
    } else {
      return false;
    }
  }
}
class PostDetail extends StatefulWidget {
  const PostDetail({Key? key}) : super(key: key);

  @override
  _PostDetaileState createState() => _PostDetaileState();
}

class _PostDetaileState extends State<PostDetail> {


  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title:  Text(
          postProvider.singlePost.title,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
        icon: Icon(Icons.clear),
          onPressed: () async {
            Navigator.pop(context);
          }
        ),

      ),
      body: Consumer<ProfileProvider>(
        builder: (context, ProfileProvider, _) => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

                Image.network(
                  postProvider.singlePost.image,
                  height: 200.0,
                  width: 300.0,
                ),


              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[

                    Text('음식종류: ${postProvider.singlePost.type}',
                        style: TextStyle(
                            fontSize: 17, color: Colors.grey[600])),
                  Text('재료: ',
                      style: TextStyle(
                          fontSize: 17, color: Colors.grey[600])),
                  Text('방법: ',
                      style: TextStyle(
                          fontSize: 17, color: Colors.grey[600])),

                  Text(postProvider.singlePost.description,
                      style: TextStyle(
                          fontSize: 17, color: Colors.grey[600])),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

}