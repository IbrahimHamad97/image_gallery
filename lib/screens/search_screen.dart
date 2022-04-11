import 'package:flutter/material.dart';
import 'package:image_gallery/firebase/database.dart';
import 'package:image_gallery/models/user_model.dart';
import 'package:image_gallery/screens/loading_screen.dart';
import 'package:image_gallery/services/shared_items.dart';

class SearchScreen extends StatefulWidget {
  final posts;
  final userData;

  const SearchScreen({Key? key, required this.posts, required this.userData}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List filtteredUsers = [];
  bool resultColor = false;
  String result = '';

  void filterList(List<UserData> users) {
    if (result == '') {
      setState(() {
        filtteredUsers = [];
      });
    } else {
      setState(() {
        filtteredUsers = users.where((item) {
          return item.userName!.toLowerCase().contains(result.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = widget.posts;
    final userData = widget.userData;
    return StreamBuilder<List<UserData>>(
        stream: DatabaseService().users,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserData> users = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter a username" : null,
                      onChanged: (val) {
                        setState(() {
                          result = val;
                        });
                        filterList(users);
                      },
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Username', hintStyle: TextStyle(color: mainColor)),
                    ),
                    SizedBox(height: 20),
                    filtteredUsers.isNotEmpty
                        ? InkWell(
                            child: Container(
                                width: double.maxFinite,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filtteredUsers.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/user_details',
                                              arguments: {
                                                'currentUser': userData,
                                                'user': filtteredUsers[index],
                                                'posts': posts
                                              });
                                        },
                                        onTapDown: (TapDownDetails details) {
                                          setState(() {
                                            resultColor = true;
                                          });
                                        },
                                        onTapCancel: () {
                                          setState(() {
                                            resultColor = false;
                                          });
                                        },
                                        onLongPressCancel: () {
                                          setState(() {
                                            resultColor = false;
                                          });
                                        },
                                        child: Container(
                                          color: resultColor
                                              ? Colors.grey[100]
                                              : Colors.transparent,
                                          margin: EdgeInsets.only(bottom: 30),
                                          child: Row(
                                            children: [
                                              filtteredUsers[index]
                                                          .profilePic !=
                                                      ''
                                                  ? CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              filtteredUsers[
                                                                      index]
                                                                  .profilePic),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage: AssetImage(
                                                          'assets/night_bg.png'),
                                                    ),
                                              SizedBox(width: 20),
                                              Text(
                                                filtteredUsers[index].userName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20, color: mainColor),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                          )
                        : Center(
                            child: Container(
                              child: Column(
                                children: [
                                  Icon(Icons.search,
                                      size: 52, color: mainColor),
                                  Text(
                                    'Search for users',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: mainColor),
                                  )
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
