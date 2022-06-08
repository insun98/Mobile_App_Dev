import 'dart:async'; // new
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart'; // new

import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // new
import 'package:intl/intl.dart';

import '../Provider/CommentProvider.dart';






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
int limit = 3;
  int count = 0 ;
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
        for(count =0; count < limit; count ++ )
          Column( children:[
            Row(
              children: [
                const SizedBox(width: 10),

                SizedBox(width:30,height:30,child:Image.network(
                  '${widget.comment[count].image_url}' ,
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
                    Text('${widget.comment[count].name}', style: TextStyle(fontSize: 13.0),),
                    SizedBox(height: 8,),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: Column (
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children :[
                          Text('${widget.comment[count].message}',style: TextStyle(fontSize: 16.0),),
                          SizedBox(height: 3,),
                          Text('${widget.comment[count].formattedDate}', style: TextStyle(fontSize: 12.0),),

                        ],
                      ),

                    ),
                  ],
                ),








              ],
            ),
            Divider(height: 10,color: Colors.grey,),
          ],
          ),
        limit  == 3  ? Center (child: TextButton(

          onPressed: ()  {
            setState(() {
              limit = widget.comment.length;
            });
          }, child: Text("댓글 ${widget.comment.length} 모두 보기", style: TextStyle(color: Colors.black),),
        ),) : Center (child: TextButton(

          onPressed: ()  {
            setState(() {
              limit = 3;
            });
          }, child: Text("댓글 그만 보기", style: TextStyle(color: Colors.black),),
        ),)
      ],
    );


  }
}





