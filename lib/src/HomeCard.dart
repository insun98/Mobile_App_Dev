import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/src/comments.dart';
import '../Provider/PostProvider.dart';
import '../Provider/ProfileProvider.dart';
import 'comments.dart';



class homeCard extends StatefulWidget {
  const homeCard({required this.posts, required this.profiles});
  final List<Post> posts;
  final List<Profile> profiles;
  @override
  _homeCardState createState() => _homeCardState();
}

class _homeCardState extends State<homeCard> {
  bool _isbooked = false;
  bool _isliked = false;
  String image = '';
  @override
  Widget build(BuildContext context) {
    List<Card> _buildListCards(BuildContext context) {
      List<Post> posts = widget.posts;
      List<Profile> profiles = widget.profiles;
      String name;
      if (posts.isEmpty) {
        return const <Card>[];
      }
      final ThemeData theme = Theme.of(context);
      final NumberFormat formatter = NumberFormat.simpleCurrency(
          locale: Localizations.localeOf(context).toString());
      ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
      return posts.map((post) {
        profileProvider.otherProfile.name="";
        profileProvider.getUser(post.creator);
        name = getName(post.creator, profiles);

        bool _isFavorited  = false;
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
                        backgroundImage: NetworkImage( '${post.creatorImage}'),
                        backgroundColor: Colors.transparent,
                      ),


                      SizedBox(width: 20,),
                      Text(
                        '${post.creatorId}',
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

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      20, 5, 0, 0),
                  child: Column(
                    // TODO: Align labels to the bottom and center (103)
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    // TODO: Change innermost Column (103)
                    children: <Widget>[
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
                          FavoriteWidget(post: post),
                          IconButton(
                            icon: const Icon(
                              Icons.chat_outlined,
                              semanticLabel: 'chatting',
                              color: Colors.black,
                              size: 25,
                            ),



                              onPressed: () async {





                               //  Navigator.pushNamed(context, '/');
                              // await commentPage.readComments(post.docId);

                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(


                                    builder: (context) => screen(postid: "${post.docId}"),
                                  )
                               );
                              },



//                            },
                          ),
                        ],
                      ),
                    ],
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

  String getName(String creatorId, List<Profile> profiles) {
    String name = "";
    for(int i=0; i < profiles.length; i++){
      if(profiles[i].uid == creatorId){
         name = profiles[i].id;

      }
    }
    return name;
  }
}

class FavoriteWidget extends StatefulWidget{


  const FavoriteWidget({required this.post});
  final Post post;
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}
class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = false;
  bool _isBooked = false;


  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);
    return Consumer<PostProvider>( builder: (context, appState, _) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon: (_isFavorited
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border)),
            color: Colors.red,
            onPressed: (){
              setState(() {
                if (_isFavorited) {
                  int num = 0;
                  num = widget.post.like -= 1 ;
                  _isFavorited = false;
                  postProvider.updateDoc(widget.post.docId, widget.post.like, _isFavorited);
                  postProvider.deletelikeuser(widget.post.docId);
                } else {
                  widget.post.like += 1;
                  _isFavorited = true;
                  postProvider.updateDoc(widget.post.docId, widget.post.like, _isFavorited);
                  postProvider.updatelikeuser(widget.post.docId);
                }
              });
            },
          ),
        ),
        Text(
          '${widget.post.like}',
        ),
        Container(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon:
            const Icon(
              Icons.book,
              color: Colors.brown,),
            onPressed:  (){
              setState(() {
                if (_isBooked) {
                  _isBooked = false;
                  postProvider.deletebook(widget.post.docId);
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: const Text("collection deleted")));
                } else {
                  _isBooked = true;
                  postProvider.updatebook(widget.post.docId);
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: const Text("collection added")));
                }
              });
            },
          ),
        ),
      ],
    ),
    );
  }
}

