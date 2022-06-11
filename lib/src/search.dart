
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/PostProvider.dart';


class searchPage extends StatefulWidget {
  const searchPage({Key? key}) : super(key: key);

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  bool _isFavorited = true;
  int _currentIndex = 0;
  String profile = " ";
  String ids = " ";

  final TextEditingController _type = TextEditingController();

  String _typeText = " ";


  _searchPageState() {


    _type.addListener(() {
      setState(() {
        _typeText = _type.text;
        // type= true;
      });
    });

  }

  _buildBody(BuildContext context) {

    // if (_typeText != " ") {
    return Expanded(
      //height: 500,
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("post")
                    .where('creatorId', isEqualTo: _typeText)
                    .snapshots(),


                builder: (context, snapshot) {
                  PostProvider postProvider = Provider.of<PostProvider>(context);

                  if (!snapshot.hasData) {
                    return Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: Text(
                        '사용자 아이디를 입력해주세요',
                      ),
                    );
                  }
                  var docum = snapshot.data!.docs;

                  int i = docum.length;

                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                      ),
                      itemCount: docum.length,
                      itemBuilder: (_, i) {
                        //  if(docum[i].data()['price']>90)

                        var post_id = docum[i].id;
                        final data = docum[i].data();
                        String creator = data['creator'];
                        String descript = data['description'];
                        String title = data['title'];
                        String type = data['type'];
                        String file = data['image'];
                        int like = data['like'];
                        final usercol = FirebaseFirestore.instance
                            .collection("user")
                            .doc("$creator");
                        usercol.get().then((value) =>
                        {
                          profile = value['image'],
                          ids = value['id'],
                        });
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
                                        backgroundImage: NetworkImage(profile),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      SizedBox(width: 15,),
                                      TextButton(
                                        onPressed: () async {},
                                        child: Text('$ids',
                                          style:
                                          TextStyle(
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
                                    file,
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
                                      title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                    ),
                                    Text(
                                      descript,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                    ),

                                    Row(
                                      children: [
                                        SizedBox(width: 250),
                                        TextButton(onPressed: () async {
                                          await postProvider.getSinglePost(
                                              post_id);
                                          Navigator.pushNamed(
                                              context, '/postDetail');
                                        }, child:
                                        Row(children: [

                                          Text(
                                            '레시피 ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,),
                                          ),
                                          SizedBox(width: 5,),
                                          Icon(Icons.menu_book,
                                              color: Color(0xFF961D36)),
                                        ],
                                        ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(color: Colors.deepOrange.shade100, height: 50),
        Container(
          // color: Colors.deepOrange.shade100,
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      flex: 6,
                      child: //TextField(

                      TextField(
                        controller: _type,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFFBF7F7),
                          prefixIcon: Icon(Icons.search),
                          hintText: '사용자 아이디를 입력하세요',
                          labelText: '사용자 아이디',
                          // icon:Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Color(0xFF961D36),
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _type.clear();
                          // _typeText = " ";
                        });
                      },
                    ), //SizedBox(width: 50),
                  ],
                ),
                SizedBox(height: 15),

              ],
            )),
        _buildBody(context),
      ],
    );
  }
}
