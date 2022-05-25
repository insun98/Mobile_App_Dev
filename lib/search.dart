
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:shrine/progress.dart';
// import 'package:shrine/user.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  bool _isFavorited  = true;
  int _currentIndex = 0;
  String profile = " ";
  String ids = " ";


  final TextEditingController _namefilter = TextEditingController();

  final TextEditingController _type = TextEditingController();
  final TextEditingController _maxprice = TextEditingController();
  final TextEditingController _minprice = TextEditingController();
  final TextEditingController _maxcalory = TextEditingController();
  final TextEditingController _mincalory  = TextEditingController();




  FocusNode focusNode = FocusNode();

  String _nameText = "";



   String _typeText = "";
  String _maxpriceText = "";
  String _minpriceText = "";

  // String _maxcaloryText = "";
  // String _mincaloryText = "";
  //
  bool name= false;
  bool type= false;
  // bool calory= false;
  // bool price= false;


  // _SearchScreenState() {
  //   _namefilter.addListener(() {
  //     setState(() {
  //       _nameText = _namefilter.text;
  //     });
  //   });
  // }

  _SearchScreenState() {
    _namefilter.addListener(() {
          setState(() {
            _nameText = _namefilter.text;
            name = true;
          });
        });

    _type.addListener(() {
      setState(() {
        _typeText = _type.text;
        type= true;
      });
    });

    _maxprice.addListener(() {
      setState(() {
        _maxpriceText = _maxprice.text;
      });
    });

    _minprice.addListener(() {
      setState(() {
        _minpriceText = _minprice.text;
      });
    });


  }



  _buildBody(BuildContext context) {
    print(11);
    var s = 'post';
    print('ㅇ에러');

    if((_nameText!='x')&&( _typeText!=""))
      {
        return Expanded(
          //height: 500,
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance.collection("post")
                        .where('title', isEqualTo: _nameText)
                    //.where('price', isLessThan : _maxpriceText ).where('price', isGreaterThanOrEqualTo : _minpriceText)
                        .where('type', isEqualTo: _typeText)
                        .snapshots(),

                    //.where('type', isEqualTo: _type.text)
                    //.where('price', isLessThan : _maxprice.text).where('price', isGreaterThanOrEqualTo : _minprice.text)
                    // .where('calory', isGreaterThanOrEqualTo : _maxcalory.text).where('calory', isGreaterThanOrEqualTo : _mincalory.text)

                    // .where('calory', isGreaterThanOrEqualTo : _maxcalory.text).where('calory', isGreaterThanOrEqualTo : _mincalory.text)
                    //.snapshots(),

                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            '검색결과가 없습니다',
                          ),
                        );
                      }
                      var docum = snapshot.data!.docs;
                      print('hihihi');

                      //final data = docum[0].data();

                      //  int p = data['price'];
                      // print(p);
                      //  var do = snapshot.data;
                      //   if(docum.['price'] > 90)
                      var new_docum;
                      int count = 0;
                      //
                      // if(type==true)
                      //   {
                      //       new_docum = docum.
                      //   }

                      // for (DocumentSnapshot d in docum) {
                      //   if(
                      //     ((d.data.toString().contains(_nameText))
                      //       && ( (type==false)||(type=true)&&(d.where('price',isGreaterThan:300)) )
                      //         && ( (name==false)||(name==true)&&(d.data.toString().contains(_nameText)) )
                      //           && ( (name==false)||(name==true)&&(d.data.toString().contains(_nameText)) ) ) {
                      //
                      //       count++;
                      //       docum = snapshot.data!.docs;
                      //
                      //   }
                      //  // else if ( (type==true) && docum.whereField("type",isEqualTo:_typeText) )
                      // }
                      //else if

                      int i = docum.length;


                      return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,),
                          itemCount: docum.length,
                          itemBuilder: (_, i) {
                            //  if(docum[i].data()['price']>90)
                            final data = docum[i].data();
                            int price = data['price'];
                            String creator = data['creator'];
                            String descript = data['description'];
                            String title = data['title'];
                            String type = data['type'];
                            String file = data['image'];
                            int like = data['like'];
                            final usercol = FirebaseFirestore.instance.collection(
                                "user").doc(
                                "$creator");
                            usercol.get().then((value) =>
                            { //값을 읽으면서, 그 값을 변수로 넣는 부분
                              profile = value['image'],
                              ids = value['id'],
                            });
                            print("${ids}");
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
                                                profile),
                                            backgroundColor: Colors
                                                .transparent,
                                          ),
                                          SizedBox(width: 20,),
                                          Text(
                                            '$ids',
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '$descript',
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
                                        file,
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
                                            '가격: $price',
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                          ),

                                          //재료 추가하기!!
                                          // Text(
                                          //   '재료: 양파(200g), 파(100g), 돼지고기(300g)',
                                          //   style: TextStyle(
                                          //     fontSize: 13,
                                          //   ),
                                          //   maxLines: 2,
                                          // ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  icon: (_isFavorited
                                                      ? const Icon(Icons.favorite)
                                                      : const Icon(
                                                      Icons.favorite_border)),
                                                  color: Colors.red,
                                                  onPressed: () {
                                                    setState(() {
                                                      if (_isFavorited) {
                                                        like -= 1;
                                                        _isFavorited = false;
                                                      } else {
                                                        like += 1;
                                                        _isFavorited = true;
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('post')
                                                            .doc("${FieldPath
                                                            .documentId}")
                                                            .update(
                                                            <String, dynamic>{
                                                              'favoritenum': like,
                                                            });
                                                      }
                                                    });
                                                  }
                                              ),
                                              Text(
                                                '${like}',
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.chat_outlined,
                                                  semanticLabel: 'chatting',
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                                onPressed: () {

                                                },
                                              ),

                                              IconButton(
                                                alignment: Alignment
                                                    .centerRight,
                                                icon: const Icon(
                                                  Icons.book_outlined,
                                                  semanticLabel: 'bookmark',
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                                onPressed: () {

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
                          }
                      );

                      // return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,), itemBuilder: (BuildContext context, int index) {  },


                      // return GridView(gridDelegate: gridDelegate)


                    },


                  ),
                ),

              ],
            ),
          ),
        );
      }
      else if(_nameText!='x')
        {
          return Expanded(
            //height: 500,
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection("post")
                          .where('title', isEqualTo: _nameText)  .snapshots(),

                      //.where('price', isLessThan : _maxpriceText ).where('price', isGreaterThanOrEqualTo : _minpriceText)
                         // .where('type', isEqualTo: _typeText)

                      //.where('type', isEqualTo: _type.text)
                      //.where('price', isLessThan : _maxprice.text).where('price', isGreaterThanOrEqualTo : _minprice.text)
                      // .where('calory', isGreaterThanOrEqualTo : _maxcalory.text).where('calory', isGreaterThanOrEqualTo : _mincalory.text)

                      // .where('calory', isGreaterThanOrEqualTo : _maxcalory.text).where('calory', isGreaterThanOrEqualTo : _mincalory.text)
                      //.snapshots(),

                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(
                              '검색결과가 없습니다',
                            ),
                          );
                        }
                        var docum = snapshot.data!.docs;
                        print('hihihi');

                        //final data = docum[0].data();

                        //  int p = data['price'];
                        // print(p);
                        //  var do = snapshot.data;
                        //   if(docum.['price'] > 90)
                        var new_docum;
                        int count = 0;
                        //
                        // if(type==true)
                        //   {
                        //       new_docum = docum.
                        //   }

                        // for (DocumentSnapshot d in docum) {
                        //   if(
                        //     ((d.data.toString().contains(_nameText))
                        //       && ( (type==false)||(type=true)&&(d.where('price',isGreaterThan:300)) )
                        //         && ( (name==false)||(name==true)&&(d.data.toString().contains(_nameText)) )
                        //           && ( (name==false)||(name==true)&&(d.data.toString().contains(_nameText)) ) ) {
                        //
                        //       count++;
                        //       docum = snapshot.data!.docs;
                        //
                        //   }
                        //  // else if ( (type==true) && docum.whereField("type",isEqualTo:_typeText) )
                        // }
                        //else if

                        int i = docum.length;


                        return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,),
                            itemCount: docum.length,
                            itemBuilder: (_, i) {
                              //  if(docum[i].data()['price']>90)
                              final data = docum[i].data();
                              int price = data['price'];
                              String creator = data['creator'];
                              String descript = data['description'];
                              String title = data['title'];
                              String type = data['type'];
                              String file = data['image'];
                              int like = data['like'];
                              final usercol = FirebaseFirestore.instance.collection(
                                  "user").doc(
                                  "$creator");
                              usercol.get().then((value) =>
                              { //값을 읽으면서, 그 값을 변수로 넣는 부분
                                profile = value['image'],
                                ids = value['id'],
                              });
                              print("${ids}");
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
                                                  profile),
                                              backgroundColor: Colors
                                                  .transparent,
                                            ),
                                            SizedBox(width: 20,),
                                            Text(
                                              '$ids',
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '$descript',
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
                                          file,
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
                                              '가격: $price',
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                              maxLines: 1,
                                            ),

                                            //재료 추가하기!!
                                            // Text(
                                            //   '재료: 양파(200g), 파(100g), 돼지고기(300g)',
                                            //   style: TextStyle(
                                            //     fontSize: 13,
                                            //   ),
                                            //   maxLines: 2,
                                            // ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    icon: (_isFavorited
                                                        ? const Icon(Icons.favorite)
                                                        : const Icon(
                                                        Icons.favorite_border)),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        if (_isFavorited) {
                                                          like -= 1;
                                                          _isFavorited = false;
                                                        } else {
                                                          like += 1;
                                                          _isFavorited = true;
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection('post')
                                                              .doc("${FieldPath
                                                              .documentId}")
                                                              .update(
                                                              <String, dynamic>{
                                                                'favoritenum': like,
                                                              });
                                                        }
                                                      });
                                                    }
                                                ),
                                                Text(
                                                  '${like}',
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.chat_outlined,
                                                    semanticLabel: 'chatting',
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {

                                                  },
                                                ),

                                                IconButton(
                                                  alignment: Alignment
                                                      .centerRight,
                                                  icon: const Icon(
                                                    Icons.book_outlined,
                                                    semanticLabel: 'bookmark',
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {

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
                            }
                        );

                        // return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,), itemBuilder: (BuildContext context, int index) {  },


                        // return GridView(gridDelegate: gridDelegate)


                      },


                    ),
                  ),

                ],
              ),
            ),
          );
        }
        else
          {
            return Expanded(
              //height: 500,
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance.collection("post")
                         //   .where('title', isEqualTo: _nameText)
                        //.where('price', isLessThan : _maxpriceText ).where('price', isGreaterThanOrEqualTo : _minpriceText)
                            .where('type', isEqualTo: _typeText)
                            .snapshots(),

                        //.where('type', isEqualTo: _type.text)
                        //.where('price', isLessThan : _maxprice.text).where('price', isGreaterThanOrEqualTo : _minprice.text)
                        // .where('calory', isGreaterThanOrEqualTo : _maxcalory.text).where('calory', isGreaterThanOrEqualTo : _mincalory.text)

                        // .where('calory', isGreaterThanOrEqualTo : _maxcalory.text).where('calory', isGreaterThanOrEqualTo : _mincalory.text)
                        //.snapshots(),

                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              child: Text(
                                '검색결과가 없습니다',
                              ),
                            );
                          }
                          var docum = snapshot.data!.docs;
                          print('hihihi');

                          //final data = docum[0].data();

                          //  int p = data['price'];
                          // print(p);
                          //  var do = snapshot.data;
                          //   if(docum.['price'] > 90)
                          var new_docum;
                          int count = 0;
                          //
                          // if(type==true)
                          //   {
                          //       new_docum = docum.
                          //   }

                          // for (DocumentSnapshot d in docum) {
                          //   if(
                          //     ((d.data.toString().contains(_nameText))
                          //       && ( (type==false)||(type=true)&&(d.where('price',isGreaterThan:300)) )
                          //         && ( (name==false)||(name==true)&&(d.data.toString().contains(_nameText)) )
                          //           && ( (name==false)||(name==true)&&(d.data.toString().contains(_nameText)) ) ) {
                          //
                          //       count++;
                          //       docum = snapshot.data!.docs;
                          //
                          //   }
                          //  // else if ( (type==true) && docum.whereField("type",isEqualTo:_typeText) )
                          // }
                          //else if

                          int i = docum.length;


                          return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,),
                              itemCount: docum.length,
                              itemBuilder: (_, i) {
                                //  if(docum[i].data()['price']>90)
                                final data = docum[i].data();
                                int price = data['price'];
                                String creator = data['creator'];
                                String descript = data['description'];
                                String title = data['title'];
                                String type = data['type'];
                                String file = data['image'];
                                int like = data['like'];
                                final usercol = FirebaseFirestore.instance.collection(
                                    "user").doc(
                                    "$creator");
                                usercol.get().then((value) =>
                                { //값을 읽으면서, 그 값을 변수로 넣는 부분
                                  profile = value['image'],
                                  ids = value['id'],
                                });
                                print("${ids}");
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
                                                    profile),
                                                backgroundColor: Colors
                                                    .transparent,
                                              ),
                                              SizedBox(width: 20,),
                                              Text(
                                                '$ids',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                ),
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '$descript',
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
                                            file,
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
                                                '가격: $price',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                              ),

                                              //재료 추가하기!!
                                              // Text(
                                              //   '재료: 양파(200g), 파(100g), 돼지고기(300g)',
                                              //   style: TextStyle(
                                              //     fontSize: 13,
                                              //   ),
                                              //   maxLines: 2,
                                              // ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      icon: (_isFavorited
                                                          ? const Icon(Icons.favorite)
                                                          : const Icon(
                                                          Icons.favorite_border)),
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        setState(() {
                                                          if (_isFavorited) {
                                                            like -= 1;
                                                            _isFavorited = false;
                                                          } else {
                                                            like += 1;
                                                            _isFavorited = true;
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection('post')
                                                                .doc("${FieldPath
                                                                .documentId}")
                                                                .update(
                                                                <String, dynamic>{
                                                                  'favoritenum': like,
                                                                });
                                                          }
                                                        });
                                                      }
                                                  ),
                                                  Text(
                                                    '${like}',
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.chat_outlined,
                                                      semanticLabel: 'chatting',
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                    onPressed: () {

                                                    },
                                                  ),

                                                  IconButton(
                                                    alignment: Alignment
                                                        .centerRight,
                                                    icon: const Icon(
                                                      Icons.book_outlined,
                                                      semanticLabel: 'bookmark',
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                    onPressed: () {

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
                              }
                          );

                          // return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,), itemBuilder: (BuildContext context, int index) {  },


                          // return GridView(gridDelegate: gridDelegate)


                        },


                      ),
                    ),

                  ],
                ),
              ),
            );
          }

  }

  //여기서 쿼리 - > search result 에 포함된 내용있으면 추가해줌
//   Widget _buildList(BuildContext context, docum {
// //  List<DocumentSnapshot> snapshot) {
//     List<DocumentSnapshot> searchResults = [];
//     for (DocumentSnapshot d in docum) {
//       if (d.data.toString().contains(_searchText)) {
//
//         docum = snapshot.data!.docs;
//         searchResults.add(d);
//       }
//     }
//     return Expanded(
//       child: GridView.count(
//           crossAxisCount: 3,
//           childAspectRatio: 1 / 1.5,
//           padding: EdgeInsets.all(3),
//           children: searchResults
//               .map((data) => _buildListItem(context, data))
//               .toList()),
//     );
//   }
//
//   Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
//    final docum =  Snapshot.data!.docs;
//     // final post = Movie.fromSnapshot(data);
//     return InkWell(
//       child: Image.network(movie.poster),
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute<Null>(
//             fullscreenDialog: true,
//             builder: (BuildContext context) {
//               return DetailScreen(movie: movie);
//             }));
//       },
//     );
//   }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


        leading: Column(

          children: const <Widget>[

            Text('Search',
                style: TextStyle(
                    fontFamily: 'Yrsa',
                    color: Color(0xFF961D36),
                    fontSize: 20)),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              semanticLabel: 'mypage',
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/mypage');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.menu,
              semanticLabel: 'logout',
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
        title: Container(width: 0,),
      ),

      body: Column(
        children: [
         // Container(color: Colors.deepOrange.shade100, height: 50),
          Container(
             // color: Colors.deepOrange.shade100,
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child:Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex :6,
                        child: TextField(
                          focusNode: focusNode,
                          style:
                          TextStyle(
                            fontSize: 15,
                          ),

                          autofocus: true,
                          controller : _type,
                          decoration: InputDecoration (
                            filled : true,
                          //  fillColor: Colors.white12,

                            prefix: Icon(
                              Icons.search,
                              color : Colors.black,
                              size : 20,
                            ),
                            suffixIcon:
                            IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size:20,
                              ),
                              onPressed : () {
                                setState(() {
                                  _type.clear();
                                  _typeText="";
                                });
                              },
                            ),

                            hintText:'  종류를 입력하세요. ',
                            labelStyle:TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.all(Radius.circular(10))),

                          ),
                        ),
                      ),

                      // Expanded(
                      //   child: TextButton (
                      //
                      //     child: Text('취소'),
                      //     onPressed: () {
                      //       setState(() {
                      //         _type.clear();
                      //         // _type = "";
                      //         focusNode.unfocus();
                      //       });
                      //     },
                      //
                      //   ),
                      // )

                    ],
                  ),
                SizedBox(height: 15,),
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: TextField(
                         // focusNode: focusNode,
                          style:
                          TextStyle(
                            fontSize: 15,
                          ),
                          autofocus: true,
                          controller : _namefilter,
                          decoration: InputDecoration (
                            filled : true,
                            //fillColor: Colors.deepOrange.shade100,
                            //SColors.oran

                            prefix: Icon(
                              Icons.search,
                              color : Colors.black,
                              size : 20,
                            ),

                            suffixIcon:
                            IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size:20,
                              ),
                              onPressed : () {
                                setState(() {
                                  _namefilter.clear();
                                  _nameText="x";
                                });
                              },
                            ),
                            hintText:'  음식의 이름을 입력하세요',
                            labelStyle:const TextStyle(color: Colors.white),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: TextButton (
                      //
                      //     child: Text('취소'),
                      //     onPressed: () {
                      //       setState(() {
                      //         _namefilter.clear();
                      //         _nameText = "";
                      //        // focusNode.unfocus();
                      //       });
                      //     },
                      //   ),
                      // )
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         flex :6,
                  //         child:
                  //
                  //         Row(
                  //           children: [
                  //             SizedBox(width: 20,),
                  //             Text('가격'),
                  //             SizedBox(width: 20,),
                  //             Expanded(
                  //               child: TextFormField(
                  //                 decoration: InputDecoration(
                  //                   labelText: '최소가격',
                  //                   hintText: '최소가격',
                  //                   border: OutlineInputBorder(),
                  //                   contentPadding: EdgeInsets.symmetric(vertical: 10),
                  //                 ),
                  //                 controller: _minprice,
                  //                 // validator: (value) {
                  //                 //   if (value.isEmpty) return 'Please enter a valid first name.';
                  //                 //   return null;
                  //                 // },
                  //               ),
                  //             ),
                  //             SizedBox(width: 10,),
                  //             Expanded(
                  //               child: TextFormField(
                  //                 style:
                  //                 TextStyle(
                  //                   fontSize: 15,
                  //                 ),
                  //                 decoration: InputDecoration(
                  //                   labelText: '최대가격',
                  //                   hintText: '최대가격',
                  //                   border: OutlineInputBorder(),
                  //                 ),
                  //                 controller: _maxprice,
                  //                 // validator: (value) {
                  //                 //   if (value.length < 1) return 'Please enter a valid last name.';
                  //                 //   return null;
                  //                 // },
                  //               ),
                  //             ),
                  //             // TextField(
                  //             //   focusNode: focusNode,
                  //             //   style:
                  //             //   TextStyle(
                  //             //     fontSize: 15,
                  //             //   ),
                  //             //   autofocus: true,
                  //             //   controller : _type,
                  //             //   decoration: InputDecoration (
                  //             //     filled : true,
                  //             //     fillColor: Colors.white12,
                  //             //
                  //             //
                  //             //     hintText:'min price  ',
                  //             //     labelStyle:TextStyle(color: Colors.white),
                  //             //     focusedBorder: OutlineInputBorder(
                  //             //         borderSide: BorderSide(color: Colors.transparent),
                  //             //         borderRadius: BorderRadius.all(Radius.circular(10))),
                  //             //     enabledBorder: OutlineInputBorder(
                  //             //         borderSide: BorderSide(color: Colors.transparent),
                  //             //         borderRadius: BorderRadius.all(Radius.circular(10))),
                  //             //     border: OutlineInputBorder(
                  //             //         borderSide: BorderSide(color: Colors.transparent),
                  //             //         borderRadius: BorderRadius.all(Radius.circular(10))),
                  //             //
                  //             //   ),
                  //             // ),
                  //           ],
                  //         )
                  //     ),
                  //     IconButton(
                  //       icon: Icon(
                  //         Icons.cancel,
                  //         size:20,
                  //       ),
                  //       onPressed : () {
                  //         setState(() {
                  //           _maxprice.clear();
                  //           _minprice.clear();
                  //           _maxprice.text="";
                  //           _minprice.text="";
                  //           //_nameText="";
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         flex :6,
                  //         child:
                  //
                  //         Row(
                  //           children: [
                  //             Expanded(child:  Text('가격')),
                  //             Expanded(
                  //               child: TextFormField(
                  //                 decoration: InputDecoration(
                  //                   labelText: '최소열량',
                  //                   hintText: '최소열량',
                  //                   border: OutlineInputBorder(),
                  //                 ),
                  //                 controller: _mincalory,
                  //                 // validator: (value) {
                  //                 //   if (value.isEmpty) return 'Please enter a valid first name.';
                  //                 //   return null;
                  //                 // },
                  //               ),
                  //             ),
                  //             SizedBox(width: 10,),
                  //             // Icon
                  //             Expanded(
                  //               child: TextFormField(
                  //                 decoration: InputDecoration(
                  //                   labelText: '최대열량',
                  //                   hintText: '최대열량',
                  //                   border: OutlineInputBorder(),
                  //                 ),
                  //                 controller: _maxcalory,
                  //                 // validator: (value) {
                  //                 //   if (value.length < 1) return 'Please enter a valid last name.';
                  //                 //   return null;
                  //                 // },
                  //               ),
                  //             ),
                  //           ],
                  //         )
                  //
                  //
                  //
                  //
                  //     ),
                  //
                  //     Expanded(
                  //       child: TextButton (
                  //
                  //         child: Text('취소'),
                  //         onPressed: () {
                  //           setState(() {
                  //             _maxcalory.clear();
                  //             _mincalory.clear();
                  //
                  //             // _type = "";
                  //             focusNode.unfocus();
                  //           });
                  //         },
                  //
                  //       ),
                  //     )
                  //
                  //   ],
                  // ),
                  // TextButton(onPressed: () { _buildBody(context);}, child: Text('검색'),),
                ],
              )
          ),
          //TextButton(onPressed: () { _buildBody(context);}, child: Text('검색'),),

          _buildBody(context),
        ],
      ),
    );
  }
}

//빌드바디에 구상한것들 넣기




// //import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shrine/progress.dart';
// import 'package:shrine/user.dart';
//
// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
//
//
// final userReference = FirebaseFirestore.instance.collection('users');
//
//
// class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage>{
//   // 검색창 입력내용 controller
//   TextEditingController searchTextEditingController = TextEditingController();
//   late Future<QuerySnapshot> futureSearchResults;
//   late CollectionReference database;
//
//
//   @override
//   void initState() {
//     super.initState();
//     database = FirebaseFirestore.instance
//         .collection("user");
//
//     //       .orderBy('price');
//     // }
//   }
//
//   Future<int> countDocuments() async {
//     QuerySnapshot _myDoc =
//     await database.get();
//     List<DocumentSnapshot> _myDocCount = _myDoc.docs;
//     return _myDocCount.length;
//   }
//
//
//
//   emptyTheTextFormField() {
//     searchTextEditingController.clear();
//   }
//
//   controlSearching(str) {
//     Future<QuerySnapshot> allUsers = userReference.where('name', isGreaterThanOrEqualTo: str).get();
//     setState(() {
//       futureSearchResults = allUsers;
//     });
//   }
//
// // 검색페이지 상단부분
//   AppBar searchPageHeader() {
//     return AppBar(
//         backgroundColor: Colors.black,
//         title: TextFormField(
//           controller: searchTextEditingController, // 검색창 controller
//           decoration: InputDecoration(
//               hintText: 'Search here....',
//               hintStyle: TextStyle(
//                 color: Colors.grey,
//               ),
//               enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.grey,)
//               ),
//               focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white,)
//               ),
//               filled: true,
//               prefixIcon: Icon(Icons.person_pin, color: Colors.white, size: 30),
//               suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.white,), onPressed: emptyTheTextFormField)
//           ),
//           style: TextStyle(
//               fontSize: 18,
//               color: Colors.white
//           ),
//           onFieldSubmitted: controlSearching,
//         )
//     );
//   }
//
//   displayNoSearchResultScreen() {
//     return Container(
//         child: Center(
//             child: ListView(
//               shrinkWrap: true,
//               children: <Widget>[
//                 Icon(Icons.group, color: Colors.grey, size: 150),
//                 Text(
//                   'Search Users',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 40
//                   ),
//                 ),
//               ],
//             )
//         )
//     );
//   }
//
//   displayUsersFoundScreen() {
//     return FutureBuilder(
//         future: futureSearchResults,
//         builder: (context, snapshot) {
//           if(!snapshot.hasData) {
//             return circularProgress();
//           }
//
//           List<UserResult> searchUserResult = [];
//           snapshot.data.document.forEach((document) {
//             User users = User.fromDocument(document);
//             UserResult userResult = UserResult(users);
//             searchUserResult.add(userResult);
//           });
//
//           return ListView(
//               children: searchUserResult
//           );
//         }
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: searchPageHeader(),
//       body: futureSearchResults == null ? displayNoSearchResultScreen() : displayUsersFoundScreen(),
//     );
//   }
//
//   // with AutomaticKeepAliveClientMixin를 추가해주고 아래 값을 true로 설정해주면 다른탭 다녀와도 initState안함
//   @override
//   bool get wantKeepAlive => true;
// }
//
// class UserResult extends StatelessWidget {
//   final User eachUser;
//   UserResult(this.eachUser);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.all(3),
//         child: Container(
//           color: Colors.white54,
//           child: Column(
//             children: <Widget>[
//               GestureDetector(
//                 onTap: () {
//                   print('tapped');
//                 },
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.black,
//                    // backgroundImage: eachUser.url == null ? circularProgress() : CachedNetworkImageProvider(eachUser.url,),
//                   ),
//                   title: Text(eachUser.name, style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   )),
//                   subtitle: Text(eachUser.profession, style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 13,
//                   )),
//                 ),
//               )
//             ],
//           ),
//         )
//     );
//   }
// }
