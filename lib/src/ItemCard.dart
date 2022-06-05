import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Provider/AuthProvider.dart';
import '../Provider/PostProvider.dart';




class itemCard extends StatefulWidget {
   itemCard({required this.myPost});

   List<Post> myPost;
  @override
  _itemCardState createState() => _itemCardState();
}

class _itemCardState extends State<itemCard> {
  @override
  Widget build(BuildContext context) {
    PostProvider postProvider= Provider.of<PostProvider>(context);
    List<Card> _buildListCards(BuildContext context) {
      List<Post> posts = widget.myPost;

      if (posts.isEmpty) {
        print("empty");
        return const <Card>[];
      }

      final ThemeData theme = Theme.of(context);
      final NumberFormat formatter = NumberFormat.simpleCurrency(
          locale: Localizations.localeOf(context).toString());

      return posts.map((post) {
        return Card(
          clipBehavior: Clip.antiAlias,
          // TODO: Adjust card heights (103)
          child: Row(
            // TODO: Center items on the card (103)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 6/ 6,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child:InkWell(
                    onTap:() async {
                      await postProvider.getSinglePost(post.docId);
                      Navigator.pushNamed(context, '/postDetail');
                    },
                  child: Image.network(

                    post.image,
                    width: 20,
                    height: 20,
                    fit: BoxFit.fill,
                  ),
                ),
                ),
              ),
            ],
          ),
        );
      }).toList();
    }

    return Flexible(
      child: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(10.0),
        childAspectRatio: 1 / 1,
        children: _buildListCards(context),
      ),
    );
  }
}
