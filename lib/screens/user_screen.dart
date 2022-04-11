import 'package:flutter/material.dart';
import 'package:image_gallery/models/user_model.dart';
import 'package:image_gallery/services/shared_items.dart';
import 'package:image_gallery/widgets/images_display.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty
        ? data
        : ModalRoute.of(context)!.settings.arguments as Map;
    final user = data['user'];
    final posts = data['posts'];
    final currentUser = data['currentUser'];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                ClipOval(
                  child: user.profilePic != ''
                      ? Image.network(
                          user.profilePic ?? '',
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        )
                      : Image.asset('assets/night_bg.png',
                          height: 200, width: 200, fit: BoxFit.fill),
                ),
                SizedBox(height: 10),
                Text(
                  user.userName ?? '',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                SizedBox(height: 10),
                Divider(),
                ImagesDisplay(
                    isRecent: true, posts: posts, currentUser: currentUser, userData: user)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
