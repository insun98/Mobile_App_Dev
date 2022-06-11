import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/src/HomeCard.dart';
import '../Provider/PostProvider.dart';
import '../Provider/ProfileProvider.dart';


class HomesPage extends StatefulWidget {
  const HomesPage({Key? key}) : super(key: key);

  @override
  _HomesPageState createState() => _HomesPageState();
}
String kind = "양식";
class _HomesPageState extends State<HomesPage> {
  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    if(kind == "양식") {
      postProvider.getTypePost('양식');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF961D36),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: kind != "양식"?Text(
                  '양식',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ):Text(
                  '양식',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {

                    kind = "양식";
                    postProvider.getTypePost(kind);

                },
              ),
              TextButton(
                child: kind != "한식"? Text(
                  '한식',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ):Text(
                  '한식',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {

                    kind = "한식";
                    postProvider.getTypePost(kind);

                },
              ),
              TextButton(
                child:  kind != "중식"? Text(
                  '중식',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ):Text(
                  '중식',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {

                    kind = "중식";
                    postProvider.getTypePost(kind);

                },
              ),
              TextButton(
                child:  kind != "일식"?Text(
                  '일식',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ):Text(
                  '일식',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {

                    kind = "일식";
                    postProvider.getTypePost(kind);

                },
              ),
            ],
          ),
        ),
        Consumer<PostProvider>(
          builder: (context, postProvider, _) => homeCard(
            posts: postProvider.typePosts,
            profiles: profileProvider.myProfile,
          ),
        ),
      ],
    );
  }
}
