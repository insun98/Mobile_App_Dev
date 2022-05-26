import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../src/ItemCard.dart';
import '../src/friendProfile.dart';
import '../Provider/AuthProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    ApplicationState authProvider = Provider.of<ApplicationState>(context);
    return Scaffold(
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
              onTap: () async {
                bool check = await authProvider.getFriend(
                    authProvider.profile.subscribers[0]);
                if (check == true) {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          friendProfile(profile: authProvider.friendProfile)));
                }
              },

            ),
            ListTile(
              leading: const Icon(
                Icons.photo_filter_outlined,
                color: Colors.black,
              ),
              title: const Text('Posts'),
              onTap: () {
                Navigator.pushNamed(context, '/friendlist');
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF961D36),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedIndex,
        //현재 선택된 Index
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/hot');
              break;
            default:
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.whatshot), label: 'Hot'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'profile'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.addchart), label: 'Ranking'),
        ],
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profileBody(

          profile: authProvider.profile,
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
              authProvider.getPosts(dropdownValue);
            });
          },
        ),),
        itemCard(
          posts: authProvider.MyPost,
        ),
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

class profileBody extends StatelessWidget {
  const profileBody({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    ApplicationState authProvider = Provider.of<ApplicationState>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(profile.photo),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 20.0),
          Text(profile.id, style: TextStyle(fontSize: 20, color: Colors.black)),
          const SizedBox(height: 10.0),
          Text(profile.name,
              style: TextStyle(fontSize: 15, color: Colors.black)),
          const SizedBox(height: 10.0),
          Text('Subscribers:${profile.subscribers.length}',
              style: TextStyle(fontSize: 15, color: Colors.black)),
          const SizedBox(height: 10.0),
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('프로필 편집'),
                style: ElevatedButton.styleFrom(primary: Color(0xFF961D36)),
                onPressed: () async {},
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
    );
  }

}
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
    ApplicationState authProvider = Provider.of<ApplicationState>(context);

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
              URL = await authProvider.UploadFile(widget.image!);


              if (_formKey.currentState!.validate()) {
                await authProvider.addItem(URL, dropdownValue,_controller.text,
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
