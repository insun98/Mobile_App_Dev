import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/Provider/MessageProvider.dart';

import '../Provider/AuthProvider.dart';
import '../Provider/CommentProvider.dart';
import '../Provider/PostProvider.dart';
import '../Provider/ProfileProvider.dart';
import 'comments.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({required this.addMessage, required this.messages});
  final FutureOr<void> Function(String message)  addMessage;
  final List<Message> messages;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _formKey  = GlobalKey<FormState> (debugLabel: '_ChatState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return Consumer<MessageProvider>(
      builder: (context, MessageProvider, _) => Scaffold(
        appBar: AppBar(
          title: Text(profileProvider.otherProfile.id),
          backgroundColor: Color(0xFF961D36),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            // const SizedBox(height: 8),
            Flexible(
              child:ListView.builder(
                padding: const EdgeInsets.all(8),
                reverse:true,
                itemCount: widget.messages.length,
                itemBuilder: (BuildContext context, int index) { return Row(

                  mainAxisAlignment: widget.messages[index].uid == FirebaseAuth.instance.currentUser!.uid?  MainAxisAlignment.end:MainAxisAlignment.start,

                  children: [
                    const SizedBox(width: 10),

                    widget.messages[index].uid == FirebaseAuth.instance.currentUser!.uid? Text(""):SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.network(
                        '${widget.messages[index].userProfile}',
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
                          width: 5,
                          height: 8,
                        ),
                        widget.messages[index].uid != FirebaseAuth.instance.currentUser!.uid?  Text(
                          '${widget.messages[index].userId}',
                          style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ): Text(""),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Column(
                            crossAxisAlignment: widget.messages[index].uid == FirebaseAuth.instance.currentUser!.uid?  CrossAxisAlignment.end:CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.messages[index].content}',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                '${widget.messages[index].time}',
                                style: TextStyle(fontSize: 10.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ); },

              )
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: '메시지를 입력하세요..',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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
                        if (_formKey.currentState!.validate())
                          await widget.addMessage(_controller.text);
                        _controller.clear();
                      },
                    ),
                  ],
                ),
              ),
              // const SizedBox(width:)
            ),

          ],
        ),
      ),
    );
  }
}

class messageView extends StatefulWidget {
  const messageView({Key? key}) : super(key: key);

  @override
  _messageViewState createState() => _messageViewState();
}

class _messageViewState extends State<messageView> {
  Widget build(BuildContext context) {
    MessageProvider messageProvider = Provider.of<MessageProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);

    return Consumer<MessageProvider>(
      builder: (context, MessageProvider, _) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: TextButton(
              style: TextButton.styleFrom(),
              child: const Text('Yori \n Jori',
                  style:
                      TextStyle(color: Color(0xFF961D36), fontFamily: 'Yrsa')),
              onPressed: () {}),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.grey,
                  semanticLabel: 'filter',
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, ProfileProvider, _) => Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                   Text(
                      '메시지',
                      style: TextStyle(
                          color: Color(0xFF961D36),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )

                  ],

                ),
              ),
              SizedBox(
                height: 500,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(30,10,10,10),
                  itemCount: MessageProvider.messageHistoryInfo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {},
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                              Image.network( MessageProvider.messageHistoryInfo[index].photo, width: 50, height: 50,),
                            TextButton(
                              onPressed: () async {
                                await profileProvider.getUser(
                                    MessageProvider.messageHistoryInfo[index].uid);
                                await MessageProvider.getMessages(
                                    MessageProvider.messageHistoryInfo[index].uid);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChatScreen(addMessage: (message) =>
                                      MessageProvider.addMessage(
                                          MessageProvider.messageHistory[index], message,profileProvider.myProfile.id,profileProvider.myProfile.photo), messages: MessageProvider.messages)),
                                );
                              },
                              child: Text(
                                "${MessageProvider.messageHistoryInfo[index].id} ",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
