import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/friendProfile.dart';
import '../Provider/ProfileProvider.dart';
import '../Provider/PostProvider.dart';
import 'package:flutter/cupertino.dart';

class rankPage extends StatefulWidget {
  const rankPage({Key? key}) : super(key: key);

  @override
  _rankPageState createState() => _rankPageState();
}

class _rankPageState extends State<rankPage> {
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);

    return Container(
      child: Consumer<ProfileProvider>(
        builder: (context, ProfileProvider, _) => Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF961D36),
              ),
              child: Row(
                children: const [
                  Text(
                    'Ranking',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: ProfileProvider.rankUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {},
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      //height: 50,
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: (index + 1).toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: ClipOval(
                              child: Image.network(
                                  ProfileProvider.rankUsers[index].photo,
                                  fit: BoxFit.fill),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(children: [
                                  SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () async {
                                      bool isSubscribed =
                                          await ProfileProvider.getUser(
                                              ProfileProvider
                                                  .rankUsers[index].uid);
                                      await postProvider.getPost(
                                          ProfileProvider.rankUsers[index].uid);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  friendProfile(
                                                      isSubscribed:
                                                          isSubscribed)));
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                          text:
                                              "${ProfileProvider.rankUsers[index].id} ",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ]),
                                Text(
                                  "     전문분야 : ${ProfileProvider.rankUsers[index].profession} ",
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "     구독자 : ${ProfileProvider.rankUsers[index].subscribers.length} ",
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(color: Colors.grey, thickness: 1.0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
