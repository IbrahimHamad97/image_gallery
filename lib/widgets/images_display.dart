import 'package:flutter/material.dart';
import 'package:image_gallery/models/user_model.dart';
import 'package:image_gallery/widgets/image_card.dart';

class ImagesDisplay extends StatefulWidget {
  final bool isRecent;
  final List posts;
  final currentUser;
  final UserData userData;

  const ImagesDisplay(
      {Key? key,
      required this.isRecent,
      required this.posts,
      this.currentUser,
      required this.userData})
      : super(key: key);

  @override
  State<ImagesDisplay> createState() => _ImagesDisplayState();
}

class _ImagesDisplayState extends State<ImagesDisplay> {
  List userPosts = [];

  @override
  Widget build(BuildContext context) {
    final posts = widget.posts;
    final userData = widget.userData;
    final currentUser = widget.currentUser;
    if (currentUser != null){
      if (userData.uid == currentUser.uid) {
        setState(() {
          userPosts = posts.where((element) => element.owner == userData.uid).toList();
        });
      }
      else {
        setState(() {
          userPosts = posts.where((element) => element.owner == userData.uid).toList();
        });
      }
    }
    return SingleChildScrollView(
      child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.fromLTRB(1, 5, 1, 0),
          child: Wrap(
              alignment: WrapAlignment.spaceAround,
              children: currentUser == null
                  ? posts
                      .map((post) {
                        return ImageCard(post: post, userData: userData);
                      })
                      .toList()
                      .cast<Widget>()
                  : userPosts
                      .map((post) {
                        return ImageCard(post: post, userData: userData);
                      })
                      .toList()
                      .cast<Widget>())),
    );
  }
}
