import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/src/comments.dart';
import '../Provider/PostProvider.dart';
import '../Provider/ProfileProvider.dart';
import 'comments.dart';
import 'friendProfile.dart';



class homeCard extends StatefulWidget {
  const homeCard({required this.posts, required this.profiles});
  final List<Post> posts;
  final Profile profiles;
  @override
  _homeCardState createState() => _homeCardState();
}

class _homeCardState extends State<homeCard> {
  bool _isbooked = false;
  String image = '';
  @override
  Widget build(BuildContext context) {
    List<Card> _buildListCards(BuildContext context) {
      List<Post> posts = widget.posts;
      Profile profiles = widget.profiles;
      String name;
      if (posts.isEmpty) {
        return const <Card>[];
      }
      final ThemeData theme = Theme.of(context);
      final NumberFormat formatter = NumberFormat.simpleCurrency(
          locale: Localizations.localeOf(context).toString());
      ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
      PostProvider postProvider= Provider.of<PostProvider>(context);
      CommentPage commentPage = Provider.of<CommentPage>(context);
      return posts.map((post) {
        profileProvider.otherProfile.name="";
        profileProvider.getUser(post.creator);
        //name = getName(post.creator, profiles);
        //commentPage.getPostComment(post.docId);
        print(commentPage.postComment.length);
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Wrap(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage( '${post.creatorImage}'),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(width: 15,),
                      TextButton(
                         onPressed: ()  async {
                        //   ProfileProvider.getUser(post.creator);
                        //   await postProvider.getPost(post.creator);
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => friendProfile(isSubscribed: true)));
                         },
                        child: Text('${post.creatorId}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AspectRatio(
                aspectRatio: 25 / 11,
                child:
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  child: Image.network(
                    post.image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      20, 5, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Text(
                        '${post.title}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),

                      Text(
                        '${post.description}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 2,
                      ),
                          FavoriteWidget(post: post, profile: profiles,),
                          /*IconButton(
                            icon: const Icon(
                              Icons.chat_outlined,
                              semanticLabel: 'chatting',
                              color: Colors.black,
                              size: 25,
                            ),
                              onPressed: () async {

                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => screen(postid: "${post.docId}"),
                                  )
                               );

                              },
                          ),*/
                    ],
                  ),
                ),
              TextButton(onPressed: () async {
                await postProvider.getSinglePost(post.docId);
                Navigator.pushNamed(context, '/postDetail');
                }, child: Text("   자세한 레시피",
                style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),)
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


  const FavoriteWidget({required this.post,required this.profile});
  final Post post;
  final Profile profile;
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}
class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = false;
  bool _isBooked = false;
  List <String> like = [];
  int count = 0;
  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);
    postProvider.getspecPost(widget.post.docId);
    like = postProvider.likeList;
   _isFavorited = false;

   for(var i in like) {
     print("hey ${i}");
     if (i == widget.profile.uid) {
       _isFavorited = true;
       break;
     }
     else{
       _isFavorited = false;
     }
   }

    return Consumer<PostProvider>( builder: (context, appState, _) => Row(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              width: 30,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.centerLeft,
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
          ],
        ),

       /* Container(
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
        ),*/
      ],
    ),
    );
  }
}

