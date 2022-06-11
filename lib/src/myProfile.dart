import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../Provider/CommentProvider.dart';
import '../src/ItemCard.dart';
import '../Provider/AuthProvider.dart';
import '../Provider/ProfileProvider.dart';
import '../Provider/PostProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import 'comments.dart';

class myProfile extends StatefulWidget {
  const myProfile({Key? key}) : super(key: key);

  @override
  _myProfileState createState() => _myProfileState();
}

class _myProfileState extends State<myProfile> {
  File? _image;
  String dropdownValue = '인기순';
  bool postOn = true;
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
                Text('구독자:${ProfileProvider.myProfile.subscribers.length}',
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
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    postOn?TextButton(
                      child: const Text(
                        '게시물',
                   style:  TextStyle(
                          color: Colors.black,
                     fontWeight: FontWeight.bold,

                        ),

                      ),
                      onPressed: () {

                      },
                    ):
                    TextButton(
                      child: const Text(
                        '게시물',
                        style:  TextStyle(
                          color: Colors.black,
                        ),

                      ),
                      onPressed: () {
                        setState(() {
                          postOn=true;
                        });
                      },
                    ),
                    postOn==false?TextButton(
                      child: const Text(
                        '북마크',
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,

                        ),

                      ),
                      onPressed: () {

                      },
                    ):TextButton(
                      child: const Text(
                        '북마크',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          postOn=false;
                        });
                      },
                    ),

                  ],
                ),

              ],
            ),
          ),
        ),

        Consumer<PostProvider>(
          builder: (context, postProvider, _) => itemCard(
            myPost: postOn?postProvider.myPost:postProvider.bookPosts,
          ),
        ),
      ],
    );
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
  Future<void> _launchUniversalLinkIos(Uri url) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

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
        title: Text(
          postProvider.singlePost.title,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () async {
              Navigator.pop(context);
            }),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, ProfileProvider, _) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  postProvider.singlePost.image,
                  height: 300.0,
                  fit: BoxFit.fill,
                width:400,
                ),
              ),
              SizedBox(height: 25),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Icon(Icons.label, color: Color(0xFF961D36)),
                        Text(postProvider.singlePost.type),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Icon(Icons.group, color: Color(0xFF961D36)),
                        Text("${postProvider.singlePost.amount.toString()}인분"),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Icon(Icons.access_alarm, color: Color(0xFF961D36)),
                        postProvider.singlePost.duration < 60
                            ? Text("60분이내")
                            : Text(
                                "${postProvider.singlePost.duration.toString()} 분"),
                      ],
                    ),
                  ),
                ],
              )),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('반찬나눔진행중',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF961D36),
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5,),
                    postProvider.singlePost.share?Row(children:[Expanded(child
                    :Text("~ ${postProvider.singlePost.date}",
                        style: TextStyle(fontSize: 18, color: Colors.black))),postProvider.singlePost.creator != FirebaseAuth.instance.currentUser!.uid?IconButton(icon:Icon(Icons.message_rounded), color: Color(0xFF961D36), onPressed: () {profileProvider.getUser(postProvider.singlePost.creator); Navigator.pushNamed(context, '/chat');  },):Text(""),],):Text("반찬 나눔 종료",
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('재료',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF961D36),
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5,),
                    Text(postProvider.singlePost.ingredients,
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('조리법',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF961D36),
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5,),
                    Text(postProvider.singlePost.description,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black)),
                    TextButton(onPressed: () async {
                      final url = Uri.parse(
                        postProvider.singlePost.blog,
                      );
                      if (await canLaunchUrl(url)) {
                        launchUrl(url);
                      } else {
                        // ignore: avoid_print
                        print("Can't launch $url");
                      }
                    }, child: Text("참조"))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('댓글',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF961D36),
                            fontWeight: FontWeight.bold)),
                    Consumer<CommentProvider>(
                      builder: (context, appState, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GuestBook(
                            addMessage: (message) =>
                                appState.addMessageToGuestBook(
                                    message, postProvider.singlePost.docId,profileProvider.myProfile.photo),
                            comment: appState.guestBookMessages, // new
                            //messages
                          ),
                        ],
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

}
