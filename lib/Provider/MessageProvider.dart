import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ProfileProvider.dart';

class MessageProvider extends ChangeNotifier {
  MessageProvider() {
    init();
  }
  StreamSubscription<QuerySnapshot>? _messsageeHistoryStream;
  List<Message> _messages = [];
  List<Message> get messages => _messages;
  List<String> _messageHistory = [];
  List<String> get messageHistory => _messageHistory;
  List<Profile> _messageHistoryInfo = [];
  List<Profile> get messageHistoryInfo => _messageHistoryInfo;
  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      _messsageeHistoryStream = FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('message')
          .snapshots()
          .listen((snapshot) {
        _messageHistory = [];
        for (final document in snapshot.docs) {
          _messageHistory.add(document.id);
        }
        _messageHistoryInfo = [];
        for (var uid in _messageHistory) {
          FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .snapshots()
              .listen((snapshot) {
            _messageHistoryInfo.add(Profile(
              name: snapshot.data()!['name'],
              id: snapshot.data()!['id'],
              email: snapshot.data()!['email'],
              uid: snapshot.id,
              bookmark: snapshot.data()!['bookmark'],
              subscribers: snapshot.data()!['subscriber'],
              subscribing: snapshot.data()!['subscribing'],
              photo: snapshot.data()!['image'],
              profession: snapshot.data()!['profession'],
            ));
            notifyListeners();
          });
          notifyListeners();
        }
      });

    });
  }

  Future<void> getMessages(String uid) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('message')
        .doc(uid)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots()
        .listen((snapshot) {
      _messages = [];
      if(snapshot.docs.isNotEmpty){
        for (final document in snapshot.docs) {
          _messages.add(Message(
              content: document.data()["content"],
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(document.data()['time'].toDate()),
              userProfile: document.data()["userProfile"],
              uid: document.data()["uid"],
              userId: document.data()["userId"]));
        }
        notifyListeners();
      }
    });
    notifyListeners();
  }
  getFriends() {
    _messageHistoryInfo = [];
    for (var userInfo in _messageHistory) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(userInfo)
          .snapshots()
          .listen((snapshot) {
        _messageHistoryInfo.add(Profile(
          name: snapshot.data()!['name'],
          id: snapshot.data()!['id'],
          email: snapshot.data()!['email'],
          uid: snapshot.id,
          bookmark: snapshot.data()!['bookmark'],
          subscribers: snapshot.data()!['subscriber'],
          subscribing: snapshot.data()!['subscribing'],
          photo: snapshot.data()!['image'],
          profession: snapshot.data()!['profession'],
        ));
        notifyListeners();
      });
    }
  }

  Future<void> addMessage(

      String uid, String content, String userId, String image) async {
    print("good");
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('message')
        .doc(uid)
        .collection('messages')
        .add(<String, dynamic>{
      'content': content,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'time': DateTime.now(),
      'userId': userId,
      'userProfile': image,
    });
    notifyListeners();

    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('message')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(<String, dynamic>{
      'content': content,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'time': FieldValue.serverTimestamp(),
      'userId': userId,
      'userProfile': image,
    });
    notifyListeners();
  }
}

class Message {
  Message({
    required this.content,
    required this.time,
    required this.userProfile,
    required this.uid,
    required this.userId,
  });
  String content;
  String time;
  String userProfile;
  String uid;
  String userId;
}
