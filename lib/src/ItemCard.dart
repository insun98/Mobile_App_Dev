import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Provider/AuthProvider.dart'
    ;




class itemCard extends StatefulWidget {
  const itemCard({required this.posts});

  final List<Post> posts;

  @override
  _itemCardState createState() => _itemCardState();
}

class _itemCardState extends State<itemCard> {
  @override
  Widget build(BuildContext context) {
    List<Card> _buildListCards(BuildContext context) {
      List<Post> posts = widget.posts;

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
                aspectRatio: 7 / 6,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Image.network(

                    post.image,
                    width: 20,
                    height: 20,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // Expanded(
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0.0, 0.0),
                child: Column(
                  // TODO: Align labels to the bottom and center (103)
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // TODO: Change innermost Column (103)
                  children: <Widget>[

                    const SizedBox(height: 5.0),
                    Text(
                      post.title,
                      style: theme.textTheme.headline6,
                      maxLines: 1,
                    ),
                    SizedBox(height:15),
                    Row(
                      children: [
                        SizedBox(height:50,width:150,child:Text(post.description, style: TextStyle(fontSize: 15))),

                         TextButton(
                            child:
                            const Text('more', style: TextStyle(fontSize: 8)),
                            onPressed: () {


                            },
                          ),

                      ],
                    ),
                  ],
                ),
                // ),
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
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 3 / 1,
        children: _buildListCards(context),
      ),
    );
  }
}
