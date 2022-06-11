import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/Provider/CommentProvider.dart';
import 'package:shrine/src/comments.dart';
import '../Provider/PostProvider.dart';
import '../Provider/ProfileProvider.dart';
import 'comments.dart';
import 'friendProfile.dart';



class homeCard extends StatefulWidget {
   homeCard({required this.posts, required this.profiles});
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
        return  <Card>[];
      }
      final ThemeData theme = Theme.of(context);
      final NumberFormat formatter = NumberFormat.simpleCurrency(
          locale: Localizations.localeOf(context).toString());
      ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
      PostProvider postProvider= Provider.of<PostProvider>(context);
      CommentProvider commentProvider= Provider.of<CommentProvider>(context);

      return posts.map((post) {
        profileProvider.otherProfile.name="";


        return Card(
          clipBehavior: Clip.antiAlias,
          child: Wrap(
            children: <Widget>[
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage( post.creatorImage),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(width: 15,),
                      TextButton(
                         onPressed: ()  async {
                           if(post.creator != FirebaseAuth.instance.currentUser!.uid) {
                             bool isSubscribed;

                             isSubscribed =
                             await profileProvider.getUser(post.creator);

                             await postProvider.getPost(post.creator);
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) =>
                                         friendProfile(isSubscribed: true)));
                           }else{
                             Navigator.pushNamed(context, '/start');
                           }
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
                aspectRatio: 24 / 11,
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
                    fit: BoxFit.fitHeight,

                  ),
                ),

              ),
                Padding(
                  padding:  EdgeInsets.fromLTRB(
                      20, 5, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height:10),

                      Text(
                        '${post.title}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height:5),
                      Text(
                        '\"${post.intro}\"',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height:10),
                      post.share?Text(
                        '반찬 나눔 진행중 ',
                        style: TextStyle(
                          fontSize: 14,fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ):Text(
                        '반찬 나눔 종료',
                        style: TextStyle(
                          fontSize: 14,fontWeight: FontWeight.bold,
                        ),

                      ),
                      SizedBox(height:5),
                      post.share?Text(
                        '~ ${post.date}',
                        style: TextStyle(
                          fontSize: 14,
                        ),

                      ):Text(" "),
                      Row(



                        mainAxisAlignment: MainAxisAlignment.end,
                          children:[
                            Row(
                           children:[IconButton(
                            icon:  Icon(
                              post.likeUsers.contains(FirebaseAuth.instance.currentUser!.uid.toString())?Icons.favorite:Icons.favorite_outline,
                              semanticLabel: 'favorite',
                              color: Color(0xFF961D36),
                              size: 25,
                            ),

                              onPressed: () async {

                                  if(post.likeUsers.contains(FirebaseAuth.instance.currentUser!.uid.toString())){
                                    postProvider.deletelikeuser(post.docId, post.like);
                                    setState(() {

                                    });
                                  }else {
                                    postProvider.updatelikeuser(post.docId, post.like);
                                    setState(() {

                                    });
                                  }

                              },

                          ),
                             Text(post.like.toString()),
                           ],),
                           IconButton(
                              icon:  Icon(
                               Icons.book,
                                semanticLabel: 'favorite',
                                color: Color(0xFF961D36),
                                size: 25,

                              ),

                              onPressed: () async {
                                await postProvider.updatebook(post.docId);

                              },
                            ),



                            IconButton(onPressed: () async {
                        await postProvider.getSinglePost(post.docId);
                        await commentProvider.init(post.docId);
                        await
                        Navigator.pushNamed(context, '/postDetail');
                      }, icon: Icon(Icons.add_to_home_screen_sharp,color: Color(0xFF961D36),
                        )
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
        padding:  EdgeInsets.all(5),
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



