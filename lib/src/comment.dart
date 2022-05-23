//post  - comment 필드추가 -> 저장하고 , read 해서 보여주기
//지금은 입력한것 그대로 str 으로 보여주기
//입력칸 -> container
//보여지는칸 - > list view


/*
TextField(
style: TextStyle(fontSize: 13, color: Colors.red),
textAlign: TextAlign.center,
decoration: InputDecoration(hintText: 'password '),
onChanged: (String str) {
setState(() => pass= str);
},
),
 */
//
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class Comment extends StatefulWidget {
//   const Comment({Key? key}) : super(key: key);
//
//   @override
//   State<Comment> createState() => _CommentState();
// }
//
// class _CommentState extends State<Comment> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title:Text('댓글'),
//       actions: [
//
//       ],),
//       body: Column (
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                   margin: const EdgeInsets.only(right: 15.0),
//                   child: CircleAvatar(child:Text('g')),
//
//
//               ),
//               Column()
//             ],
//           )
//         ]
//       )
//     );
//
//
//   }
// }
//
//


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String _name = 'hee';
int _favoriteCount = 12;




class Comment extends StatelessWidget {
  const Comment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '댓글',
      home: ChatScreen(),
    );
  }
}



class ChatMessage extends StatelessWidget {


  const ChatMessage({
    required this.text,
    Key? key,
  }) : super(key: key);
  final String text;



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //margin: const EdgeInsets.only(right: 16.0),

            child: CircleAvatar(child:Image.network('https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206')),

            // child: CircleAvatar(child: Text(_name[0])),
          ),
          Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 5, height: 8,
              ),
              Text(_name, style: TextStyle(fontSize: 13.0),),
              SizedBox(height: 8,),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,

     children :[
       Text(text,style: TextStyle(fontSize: 16.0),),

       Row (children: [
         SizedBox(
           child: Expanded(
          // padding: const EdgeInsets.all(0),
           child:
           const FavoriteWidget(),

           //   IconButton(
         //     padding: const EdgeInsets.all(0),
         //     alignment: Alignment.centerRight,
         //     icon: (_isFavorited
         //         ? const Icon(Icons.monitor_heart_rounded),
         //        // : const Icon(Icons.monitor_heart_rounded_border)),
         //     color: Colors.red,
         //   ), onPressed: () {  },
         // ),
           ),

         ),

       ],
       ),


      ]
    ),

              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late CollectionReference database;

  //late query database;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database = FirebaseFirestore.instance
        .collection("user");

    //       .orderBy('price');
    // }
  }

  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _handleSubmitted(String text) {
    _textController.clear();
    var message = ChatMessage(
      text: text,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('댓글'),actions: [],),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),

          const Divider(height: 1.0),


          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: false,
              itemBuilder: (_, index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [

        Container(
                  margin: const EdgeInsets.all(15.0),
                  child: CircleAvatar(child:Image.network('https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206')),


              ),
            // 너비 추가 height: 200,
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                const InputDecoration.collapsed(hintText: '댓글추가...'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }
}


// #docregion FavoriteWidget
class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({Key? key}) : super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}
// #enddocregion FavoriteWidget

// #docregion _FavoriteWidgetState, _FavoriteWidgetState-fields, _FavoriteWidgetState-build
class _FavoriteWidgetState extends State<FavoriteWidget> {
  // #enddocregion _FavoriteWidgetState-build
  bool _isFavorited = true;
  int _favoriteCount = 0;

  // #enddocregion _FavoriteWidgetState-fields

  // #docregion _toggleFavorite
  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  // #enddocregion _toggleFavorite

  // #docregion _FavoriteWidgetState-build
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //  mainAxisSize: MainAxisSize.min,
      children: [

        Container(

          //padding: const EdgeInsets.all(0),
          child: Row ( children :[
            IconButton(

              //  padding: const EdgeInsets.all(0),
              //  alignment: Alignment.centerRight,
              icon: (_isFavorited
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border)),
              color: Colors.black,
              onPressed: _toggleFavorite,
            ),
            SizedBox(
              width: 18,
              child: SizedBox(
                child: Text('$_favoriteCount'),
              ),
            ),
            IconButton(

              //  padding: const EdgeInsets.all(0),
              //  alignment: Alignment.centerRight,
              icon: (_isFavorited
                  ? const Icon(Icons.comment)
                  : const Icon(Icons.comment)),
              color: Colors.black,
              onPressed: _toggleFavorite,
            ),

    ],
    )

        ),
        SizedBox(
          width: 18,
          child: SizedBox(
            child: Text('0'),
          ),
        ),
      ],
    );
  }
// #docregion _FavoriteWidgetState-fields
}

