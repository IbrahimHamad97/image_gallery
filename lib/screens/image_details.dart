import 'package:flutter/material.dart';
import 'package:image_gallery/firebase/database.dart';
import 'package:image_gallery/models/user_model.dart';
import 'package:image_gallery/services/shared_items.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ImageDetails extends StatefulWidget {
  const ImageDetails({
    Key? key,
  }) : super(key: key);

  @override
  _ImageDetailsState createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> {
  bool isLiked = false;
  Map data = {};

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserData?>(context);
    data = data.isNotEmpty
        ? data
        : ModalRoute.of(context)!.settings.arguments as Map;
    final post = data['post'];
    final userData = data['userData'];
    final List likers = data['likers'];
    final dt =
        DateTime.fromMillisecondsSinceEpoch(post.createdAt.seconds * 1000);
    final time = DateFormat('dd/MM/yyyy, HH:mm').format(dt);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: NetworkImage(post.imageUrl),
                width: double.maxFinite,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        post.ownerUsername,
                        style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      time.toString(),
                      style: TextStyle(color: mainColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      post.likes.toString(),
                      style: TextStyle(
                        fontSize: 30,
                        color: mainColor,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      post.likedBy!.contains(userData.uid)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 40,
                      color: mainColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              likers.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                          children: List.generate(likers.length, (index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 20,
                                        backgroundImage: likers[index]
                                                    ['profilePic'] !=
                                                ''
                                            ? NetworkImage(
                                                likers[index]['profilePic'])
                                            : AssetImage('assets/night_bg.png')
                                                as ImageProvider),
                                    SizedBox(width: 15),
                                    Text(
                                      likers[index]['userName'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: mainColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.favorite, color: mainColor)
                              ]),
                        );
                      })),
                    )
                  : Container(),
              SizedBox(height: 10),
              currentUser!.uid == post.owner || userData.role == 'admin'
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            DatabaseService().deletePost(post.id);
                            Navigator.pop(context);
                          },
                          child: Text('Delete Post'),
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
