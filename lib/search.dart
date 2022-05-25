//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:shrine/progress.dart';
//import 'package:shrine/user.dart';



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

  // String _typeText = "";
  // String _maxpriceText = "";
  // String _minpriceText = "";
  // String _maxcaloryText = "";
  // String _mincaloryText = "";
  //
  // bool name= false;
  // bool type= false;
  // bool calory= false;
  // bool price= false;


  _SearchScreenState() {
    _namefilter.addListener(() {
      setState(() {
        _nameText = _namefilter.text;
      });
    });
  }



  Widget _buildBody(BuildContext context) {
    var s = 'post';
    return Center (
      child:Column(
        children: [
          Expanded(
            child:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
              stream: FirebaseFirestore.instance.collection("post").where('type', isEqualTo: _type.text)
                  .where('price', isLessThan : _maxprice.text).where('price', isGreaterThanOrEqualTo : _minprice.text).snapshots(),

              builder: (context, snapshot) {
                //if (!snapshot.hasData) return LinearProgressIndicator();
                var docum = snapshot.data!.docs;
                //  var do = snapshot.data;
                var new_docum ;
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
                      final data = docum[i].data();
                      int price = data['price'];
                      String creator = data['creator'];
                      String descript = data['description'];
                      String title = data['title'];
                      String type = data['type'];
                      String file = data['image'];
                      int like = data['like'];
                      final usercol = FirebaseFirestore.instance.collection("user").doc(
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
                                                : const Icon(Icons.favorite_border)),
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
                                                      .doc("${FieldPath.documentId}")
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
    );

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
    return Container(
      child:Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30),

          ),
          Container(
              color: Colors.grey,
              padding: EdgeInsets.fromLTRB(5,10, 5, 10),
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
                          controller : _namefilter,
                          decoration: InputDecoration (
                            filled : true,
                            fillColor: Colors.white12,
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
                                  _nameText="";
                                });
                              },
                            ),
                            hintText:'음식의 이름을 입력하세요',
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

                      Expanded(
                        child: TextButton (

                          child: Text('취소'),
                          onPressed: () {
                            setState(() {
                              _namefilter.clear();
                              _nameText = "";
                              focusNode.unfocus();
                            });
                          },

                        ),
                      )

                    ],
                  ),


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
                            fillColor: Colors.white12,


                            hintText:'종류를 입력하세요. ',
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

                      Expanded(
                        child: TextButton (

                          child: Text('취소'),
                          onPressed: () {
                            setState(() {
                              _type.clear();
                              // _type = "";
                              focusNode.unfocus();
                            });
                          },

                        ),
                      )

                    ],
                  ),



                  Row(
                    children: [
                      Expanded(
                          flex :6,
                          child:

                          Row(
                            children: [
                              Expanded(child:  Text('가격')),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: '최소가격',
                                    hintText: '최소가격',
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: _minprice,
                                  // validator: (value) {
                                  //   if (value.isEmpty) return 'Please enter a valid first name.';
                                  //   return null;
                                  // },
                                ),
                              ),
                              SizedBox(width: 10,),
                              // Icon
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: '최대가격',
                                    hintText: '최대가격',
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: _maxprice,
                                  // validator: (value) {
                                  //   if (value.length < 1) return 'Please enter a valid last name.';
                                  //   return null;
                                  // },
                                ),
                              ),



                              // TextField(
                              //   focusNode: focusNode,
                              //   style:
                              //   TextStyle(
                              //     fontSize: 15,
                              //   ),
                              //   autofocus: true,
                              //   controller : _type,
                              //   decoration: InputDecoration (
                              //     filled : true,
                              //     fillColor: Colors.white12,
                              //
                              //
                              //     hintText:'min price  ',
                              //     labelStyle:TextStyle(color: Colors.white),
                              //     focusedBorder: OutlineInputBorder(
                              //         borderSide: BorderSide(color: Colors.transparent),
                              //         borderRadius: BorderRadius.all(Radius.circular(10))),
                              //     enabledBorder: OutlineInputBorder(
                              //         borderSide: BorderSide(color: Colors.transparent),
                              //         borderRadius: BorderRadius.all(Radius.circular(10))),
                              //     border: OutlineInputBorder(
                              //         borderSide: BorderSide(color: Colors.transparent),
                              //         borderRadius: BorderRadius.all(Radius.circular(10))),
                              //
                              //   ),
                              // ),





                            ],
                          )




                      ),

                      Expanded(
                        child: TextButton (

                          child: Text('취소'),
                          onPressed: () {
                            setState(() {
                              _maxprice.clear();
                              _minprice.clear();

                              // _type = "";
                              focusNode.unfocus();
                            });
                          },

                        ),
                      )

                    ],
                  ),


                  Row(
                    children: [
                      Expanded(
                          flex :6,
                          child:

                          Row(
                            children: [
                              Expanded(child:  Text('가격')),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: '최소열량',
                                    hintText: '최소열량',
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: _mincalory,
                                  // validator: (value) {
                                  //   if (value.isEmpty) return 'Please enter a valid first name.';
                                  //   return null;
                                  // },
                                ),
                              ),
                              SizedBox(width: 10,),
                              // Icon
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: '최대열량',
                                    hintText: '최대열량',
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: _maxcalory,
                                  // validator: (value) {
                                  //   if (value.length < 1) return 'Please enter a valid last name.';
                                  //   return null;
                                  // },
                                ),
                              ),
                            ],
                          )




                      ),

                      Expanded(
                        child: TextButton (

                          child: Text('취소'),
                          onPressed: () {
                            setState(() {
                              _maxcalory.clear();
                              _mincalory.clear();

                              // _type = "";
                              focusNode.unfocus();
                            });
                          },

                        ),
                      )

                    ],
                  ),




                ],




              )

          ),
          _buildBody(context)
        ],
      ),
    );
  }
}