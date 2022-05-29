import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Provider/AuthProvider.dart';
import '../Provider/PostProvider.dart';



class bookCard extends StatefulWidget {
  const bookCard({required this.posts});
   final List<Post> posts;

  @override
  _bookCardState createState() => _bookCardState();
}

class _bookCardState extends State<bookCard> {
  bool _isFavorited  = false;
  bool _isbooked = false;
  @override
  Widget build(BuildContext context) {
    List<Card> _buildListCards(BuildContext context) {
      List<Post> posts = widget.posts;
      List<Post> posts1 = [];
      if (posts.isEmpty) {
        return const <Card>[];
      }
     // print("${posts.length}");
      final ThemeData theme = Theme.of(context);
      final NumberFormat formatter = NumberFormat.simpleCurrency(
          locale: Localizations.localeOf(context).toString());
      //print("${profile.subscribers[0]}");
      //for(int i=0;i<posts.length;i++){
        //for(int j=0;j<profile.bookmark.length;j++){
          //print("${posts[i].docId}");
          //if(posts[i].docId == profile.bookmark[j]){
           //posts1.add(posts[i]);
           //print("${profile.id}: ${profile.bookmark[0]}");
          //}
       // }
      //}
      if (posts1.isEmpty) {
        //print("empty");
        return const <Card>[];
      }
      return posts1.map((post) {
        print("${post.creator}");
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Wrap(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206'),
                        backgroundColor: Colors.transparent,
                      ),


                      SizedBox(width: 20,),
                      Text(
                        'hi',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                  Text(
                    '${post.description}',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
              AspectRatio(
                aspectRatio: 25 / 11,
                child:
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    post.image,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      20, 5, 0, 0),
                  child: Column(
                    // TODO: Align labels to the bottom and center (103)
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    // TODO: Change innermost Column (103)
                    children: <Widget>[
                      /*Text(
                                              '$name',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                              maxLines: 1,
                                            ),*/
                      // TODO: Handle overflowing labels (103)
                      Text(
                        '열량: ',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        '가격: ${post.price}',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        '재료: 양파(200g), 파(100g), 돼지고기(300g)',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                        maxLines: 2,
                      ),
                      Row(
                        children: [
                          IconButton(
                              icon:(_isFavorited
                                  ? const Icon(Icons.favorite)
                                  : const Icon(Icons.favorite_border)),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  if (_isFavorited) {
                                    //  like -= 1;
                                    _isFavorited = false;

                                  } else {
                                    // like += 1;
                                    _isFavorited = true;


                                  }
                                });


                              }
                          ),
                          Text(
                            '${post.like}',
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.chat_outlined,
                              semanticLabel: 'chatting',
                              color: Colors.black,
                              size: 25,
                            ),
                            onPressed: () {

                            },
                          ),
                          IconButton(
                            icon:(_isbooked
                                ? const Icon(Icons.book)
                                : const Icon(Icons.book_outlined)),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                if (_isbooked) {
                                  //  like -= 1;
                                  _isbooked = false;
                                } else {
                                  // like += 1;
                                  _isbooked = true;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList();
    }

    // TODO: implement build
    return Flexible(
      child: GridView.count(
        crossAxisCount: 1,
        padding: const EdgeInsets.all(5),
        childAspectRatio: 1 / 1,
        children: _buildListCards(context),
      ),
    );
  }
}
