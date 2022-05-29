// import 'package:flutter/material.dart';
// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:provider/provider.dart';
// import 'dart:io';
//
// import '../src/ItemCard.dart';
// import '../Provider/AuthProvider.dart';
// import '../Provider/ProfileProvider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class friendProfile extends StatefulWidget {
//   friendProfile({required this.profile});
//   Profile profile;
//   @override
//   _friendProfileState createState() => _friendProfileState();
// }
//
// class _friendProfileState extends State<friendProfile> {
//   int _selectedIndex = 0;
//   File? _image;
//   String dropdownValue = '인기순';
//   Widget build(BuildContext context) {
//     ApplicationState authProvider = Provider.of<ApplicationState>(context);
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         bottomOpacity: 0.0,
//         elevation: 0.0,
//         leading: TextButton(
//             style: TextButton.styleFrom(),
//             child: Text('Yori \n Jori',
//                 style: TextStyle(color: Color(0xFF961D36), fontFamily: 'Yrsa')),
//             onPressed: () {}),
//         actions: <Widget>[
//           Builder(
//             builder: (context) => IconButton(
//               color: Colors.black,
//               icon: const Icon(Icons.menu),
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//             ),
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         backgroundColor: Colors.white,
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const Padding(
//               child: Text('Yori  Jori',
//                   style: TextStyle(
//                       color: Color(0xFF961D36),
//                       fontFamily: 'Yrsa',
//                       fontSize: 30)),
//               padding: EdgeInsets.only(top: 40, left: 10),
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(
//                 Icons.people,
//                 color: Color(0xFF961D36),
//               ),
//               title: const Text(
//                 'Subscribers',
//                 style: TextStyle(color: Color(0xFF961D36)),
//               ),
//               onTap: () {},
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(
//                 Icons.photo_filter_outlined,
//                 color: Colors.black,
//               ),
//               title: const Text('Posts'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/friendlist');
//               },
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(
//                 Icons.settings,
//                 color: Color(0xFF961D36),
//               ),
//               title: const Text('Settings'),
//               onTap: () {},
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Color(0xFF961D36),
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white.withOpacity(.60),
//         selectedFontSize: 14,
//         unselectedFontSize: 14,
//         currentIndex: _selectedIndex,
//         //현재 선택된 Index
//         onTap: (int index) {
//           switch (index) {
//             case 1:
//               Navigator.pushNamed(context, '/');
//               break;
//             case 2:
//               Navigator.pushNamed(context, '/');
//               break;
//             default:
//           }
//         },
//
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.whatshot), label: 'Hot'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.account_circle), label: 'profile'),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//           BottomNavigationBarItem(icon: Icon(Icons.addchart), label: 'Ranking'),
//         ],
//       ),
//       body: Consumer<ApplicationState>(
//         builder: (context, appState, _) => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             profileBody(
//               profile: authProvider.profile,
//             ),
//             Container(
//               margin: EdgeInsets.only(left: 35),
//               child: DropdownButton<String>(
//                 value: dropdownValue,
//                 icon: const Icon(Icons.arrow_drop_down_outlined),
//                 elevation: 0,
//                 style: const TextStyle(color: Colors.black),
//                 items: dropdownItems,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     dropdownValue = newValue!;
//                     authProvider.getPosts(dropdownValue);
//                   });
//                 },
//               ),
//             ),
//             itemCard(
//               posts: authProvider.MyPost,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<bool> getImageFromGallery(ImageSource imageSource) async {
//     var image = await ImagePicker.platform
//         .pickImage(source: imageSource, maxWidth: 650, maxHeight: 100);
//     setState(() {
//       _image = File(image!.path);
//     });
//     if (image != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   List<DropdownMenuItem<String>> get dropdownItems {
//     List<DropdownMenuItem<String>> menuItems = [
//       DropdownMenuItem(child: Text("인기순"), value: "인기순"),
//       DropdownMenuItem(child: Text("가장 오래된 순"), value: "가장 오래된 순"),
//       DropdownMenuItem(child: Text("최신순"), value: "최신순"),
//     ];
//     return menuItems;
//   }
// }
//
// class profileBody extends StatelessWidget {
//   const profileBody({required this.profile});
//
//   final Profile profile;
//
//   @override
//   Widget build(BuildContext context) {
//     ApplicationState authProvider = Provider.of<ApplicationState>(context);
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             radius: 30.0,
//             backgroundImage: NetworkImage(profile.photo),
//             backgroundColor: Colors.transparent,
//           ),
//           const SizedBox(height: 20.0),
//           Text(profile.id, style: TextStyle(fontSize: 20, color: Colors.black)),
//           const SizedBox(height: 10.0),
//           Text(profile.name,
//               style: TextStyle(fontSize: 15, color: Colors.black)),
//           const SizedBox(height: 10.0),
//           Text('Subscribers:${profile.subscribers.length}',
//               style: TextStyle(fontSize: 15, color: Colors.black)),
//           const SizedBox(height: 10.0),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//
//               ElevatedButton(
//                 child: const Text('Subsribe'),
//                 style: ElevatedButton.styleFrom(primary: Color(0xFF961D36)),
//                 onPressed: () async {
//                   authProvider.signOut();
//                   Navigator.pushNamed(context, '/login');
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
