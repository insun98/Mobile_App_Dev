// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shrine/src/myProfile.dart';
// import '../Provider/AuthProvider.dart';
// import '../Provider/PostProvider.dart';
// import '../Provider/ProfileProvider.dart';
//
//
//
// class bookCard extends StatefulWidget {
//   const bookCard({required this.mybook, required this.posts, required this.myprofile});
//    final List<Post> posts;
//    final Profile myprofile;
//    final List<Post> mybook;
//   @override
//   _bookCardState createState() => _bookCardState();
// }
//
// class _bookCardState extends State<bookCard> {
//   bool _isFavorited  = false;
//   bool _isbooked = false;
//   @override
//   Widget build(BuildContext context) {
//     ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
//     List<Card> _buildListCards(BuildContext context) {
//       //profileProvider.getBookmark();
//       List<Post> posts =  profileProvider.myBookPost;
//       List<Post> book = widget.mybook;
//       print("${posts.length}");
//
//       if (posts.isEmpty) {
//         return const <Card>[];
//       }
//      // print("${posts.length}");
//       final ThemeData theme = Theme.of(context);
//       final NumberFormat formatter = NumberFormat.simpleCurrency(
//           locale: Localizations.localeOf(context).toString());
//       if (posts.isEmpty) {
//         print("empty");
//         return const <Card>[];
//       }
//       return posts.map((post) {
//         profileProvider.getUser(post.creator);
//         return Card(
//           clipBehavior: Clip.antiAlias,
//           child: Wrap(
//             //crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Column(
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 20.0,
//                         backgroundImage: NetworkImage(
//                             '${post.creatorImage}'),
//                         backgroundColor: Colors.transparent,
//                       ),
//
//
//                       SizedBox(width: 20,),
//                       Text(
//                         '${post.creatorId}',
//                         style: TextStyle(
//                           fontSize: 13,
//                         ),
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                   Text(
//                     '${post.description}',
//                     style: TextStyle(
//                       fontSize: 13,
//                     ),
//                     maxLines: 2,
//                   ),
//                 ],
//               ),
//               AspectRatio(
//                 aspectRatio: 25 / 11,
//                 child:
//                 ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(10),
//                     bottomRight: Radius.circular(10),
//                   ),
//                   child: Image.network(
//                     post.image,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(
//                       20, 5, 0, 0),
//                   child: Column(
//                     // TODO: Align labels to the bottom and center (103)
//                     crossAxisAlignment: CrossAxisAlignment
//                         .start,
//                     // TODO: Change innermost Column (103)
//                     children: <Widget>[
//                       /*Text(
//                                               '$name',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 13,
//                                               ),
//                                               maxLines: 1,
//                                             ),*/
//                       // TODO: Handle overflowing labels (103)
//                       Text(
//                         '열량: ',
//                         style: TextStyle(
//                           fontSize: 13,
//                         ),
//                         maxLines: 1,
//                       ),
//
//                       Text(
//                         '재료: 양파(200g), 파(100g), 돼지고기(300g)',
//                         style: TextStyle(
//                           fontSize: 13,
//                         ),
//                         maxLines: 2,
//                       ),
//                       Row(
//                         children: [
//                           FavoriteWidget(post: post),
//                           IconButton(
//                             icon: const Icon(
//                               Icons.chat_outlined,
//                               semanticLabel: 'chatting',
//                               color: Colors.black,
//                               size: 25,
//                             ),
//                             onPressed: () {
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList();
//     }
//
//     // TODO: implement build
//     return Flexible(
//       child: GridView.count(
//         crossAxisCount: 1,
//         padding: const EdgeInsets.all(5),
//         childAspectRatio: 1 / 1,
//         children: _buildListCards(context),
//       ),
//     );
//   }
// }
//
// class FavoriteWidget extends StatefulWidget{
//
//
//   const FavoriteWidget({required this.post});
//   final Post post;
//   @override
//   _FavoriteWidgetState createState() => _FavoriteWidgetState();
// }
// class _FavoriteWidgetState extends State<FavoriteWidget> {
//   bool _isFavorited = false;
//   bool _isBooked = false;
//
//
//   @override
//   Widget build(BuildContext context) {
//     PostProvider postProvider = Provider.of<PostProvider>(context);
//     return Consumer<PostProvider>( builder: (context, appState, _) => Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(0),
//           child: IconButton(
//             padding: const EdgeInsets.all(0),
//             alignment: Alignment.centerRight,
//             icon: (_isFavorited
//                 ? const Icon(Icons.favorite)
//                 : const Icon(Icons.favorite_border)),
//             color: Colors.red,
//             onPressed: (){
//               setState(() {
//                 if (_isFavorited) {
//                   int num = 0;
//                   num = widget.post.like -= 1 ;
//                   _isFavorited = false;
//                   postProvider.updateDoc(widget.post.docId, widget.post.like, _isFavorited);
//                   postProvider.deletelikeuser(widget.post.docId);
//                 } else {
//                   widget.post.like += 1;
//                   _isFavorited = true;
//                   postProvider.updateDoc(widget.post.docId, widget.post.like, _isFavorited);
//                   postProvider.updatelikeuser(widget.post.docId);
//                 }
//               });
//             },
//           ),
//         ),
//         Text(
//           '${widget.post.like}',
//         ),
//         Container(
//           padding: const EdgeInsets.all(0),
//           child: IconButton(
//             padding: const EdgeInsets.all(0),
//             alignment: Alignment.centerRight,
//             icon:
//             const Icon(
//               Icons.book,
//               color: Colors.brown,),
//             onPressed:  (){
//               setState(() {
//                 if (_isBooked) {
//                   _isBooked = false;
//                   postProvider.deletebook(widget.post.docId);
//                   Scaffold.of(context)
//                       .showSnackBar(SnackBar(content: const Text("collection deleted")));
//                 } else {
//                   _isBooked = true;
//                   postProvider.updatebook(widget.post.docId);
//                   Scaffold.of(context)
//                       .showSnackBar(SnackBar(content: const Text("collection added")));
//                 }
//               });
//             },
//           ),
//         ),
//       ],
//     ),
//     );
//   }
// }