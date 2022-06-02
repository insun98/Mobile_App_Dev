import 'dart:async'; // new
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart'; // new

import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // new
import 'package:intl/intl.dart';
import 'package:shrine/src/LoginState.dart';

int _users = 0;
int get users => _users;


class screen extends StatefulWidget {
   screen({required this.postid});

  String postid;
  @override
  State<screen> createState() => _screenState();
}



class _screenState extends State<screen> {
 //String postId = widget.postid
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('댓글'),

      ),
      body: ListView(
        children: [

          Consumer<CommentPage>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GuestBook(
                  addMessage: (message) =>
                      appState.addMessageToGuestBook(message,widget.postid),
                  comment: appState.guestBookMessages, // new
                  //messages
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






// class Screen extends StatelessWidget {
//   const Screen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('댓글'),
//
//       ),
//       body: ListView(
//         children: [
//
//       Consumer<CommentPage>(
//       builder: (context, appState, _) => Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GuestBook(
//           addMessage: (message) =>
//               appState.addMessageToGuestBook(message,postId),
//           comment: appState.guestBookMessages, // new
//           //messages
//         ),
//       ],
//     ),
//     ),
//         ],
//       ),
//     );
//   }
// }


class CommentPage extends ChangeNotifier {

  late String doc_id = "23Eak9GbU2B1HAKMmKKi";

 CommentPage(String d_id) {
    init();
    doc_id = "23Eak9GbU2B1HAKMmKKi";
  }

  var s;
  var doc_image;


  Future<DocumentReference> addMessageToGuestBook(String message, String postId) async{


    return FirebaseFirestore.instance
        .collection('post')
        .doc(doc_id)
        .collection('comment')
        .add(<String, dynamic>{
      'text': message,
      'timestamp': DateTime
          .now()
          .millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'image_url': doc_image.data()!['image'],
      //FirebaseAuth.instance.currentUser!.photoURL,
      //FirebaseAuth.instance.currentUser!.image,

    });
  }

  Future<void> init() async {
    doc_image = await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser?.uid).get();

    FirebaseFirestore.instance
        .collection('post')
        .doc(doc_id)
        .collection('comment')
        .snapshots()
        .listen((snapshot) {
      _users = snapshot.docs.length;
      notifyListeners();
    });
    
    // FirebaseFirestore.instance
    //     .collection('user')
    //     .snapshots()
    //     .listen((snapshot) {
    //   _users = snapshot.docs.length;
    //   notifyListeners();
    // });

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
      //  _loginState = ApplicationState.loggedIn;
        _guestBookSubscription = FirebaseFirestore.instance
            .collection('post').doc(doc_id)
            .collection('comment')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) { //comemnt 바뀔떄마다 새로 그려줌!!!
          _guestBookMessages = [];
          for (final document in snapshot.docs) {
            _guestBookMessages.add(
              Com(
              name: document.data()['name'] as String,
              message: document.data()['text'] as String,
              formattedDate: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(DateTime.now()) as String,
                image_url: document.data()['image_url'] as String,
            ),
            );
          }
          notifyListeners();
        });
      }
      else {
       //_loginState = ApplicationState.signOut();
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
      }
      notifyListeners();
    });
  }


  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;

  ApplicationLoginState get loginState => _loginState;

  //user 선언


  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<Com> _guestBookMessages = [];

  List<Com> get guestBookMessages => _guestBookMessages;


}

class GuestBook extends StatefulWidget {
  const GuestBook({required this.addMessage, required this.comment});
  final FutureOr<void> Function(String message)  addMessage;
  final List<Com> comment;

  @override
  State<GuestBook> createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey  = GlobalKey<FormState> (debugLabel: '_GuestBookState');
  final _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:  CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
           child:Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller ,
                  decoration : const InputDecoration(
                    hintText: '댓글을 입력하세요..',
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty ) {
                  return '다시 입력하세요';
                  }
                    return null;
                    },
                ),
              ),
              const SizedBox(width: 8),
               IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
    if(_formKey.currentState!.validate())
    await widget.addMessage(_controller.text);
    _controller.clear();
    },
    ),

  ],
              ),
          ),
                    // const SizedBox(width:)

          ),

        // const SizedBox(height: 8),
        for( var com in widget.comment)
          Column( children:[
          Row(
            children: [
              const SizedBox(width: 10),

          SizedBox(width:30,height:30,child:Image.network(
              '${com.image_url}' ,
          ),
                // child: CircleAvatar(child: Text(_name[0])),
              ),
             // ),
              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 5, height: 8,
                  ),
                  Text('${com.name}', style: TextStyle(fontSize: 13.0),),
                  SizedBox(height: 8,),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Column (
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children :[
                          Text('${com.message}',style: TextStyle(fontSize: 16.0),),
                          SizedBox(height: 3,),
                          Text('${com.formattedDate}', style: TextStyle(fontSize: 12.0),),

                          //            Container(
                          //                 margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          //                 child: IconButton(
                          //                   icon: Icon(Icons.delete_outline),
                          //                   onPressed: () => {},
                          //                 ),
                          //               )

                        ],
                    ),

                  ),
                ],
              ),



          //       children:[
          //         //Paragraph('${comment.name}'),
          // ],
          //     ),






            ],
                  ),
            Divider(height: 10,color: Colors.grey,),
    ],
    ),
      ],
        );


  }
}


class Com {
  Com(
      {required this.name, required this.message, required this.formattedDate, required this.image_url});
  final String name;
  final String message;
  final String formattedDate;
  final String image_url;
}


