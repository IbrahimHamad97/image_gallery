import 'package:flutter/material.dart';
import 'package:image_gallery/firebase/database.dart';
import 'package:image_gallery/models/post_model.dart';
import 'package:image_gallery/models/user_model.dart';
import 'package:image_gallery/services/shared_items.dart';

class ImageCard extends StatefulWidget {
  final PostData post;
  final UserData userData;

  ImageCard({Key? key, required this.post, required this.userData})
      : super(key: key);

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final userData = widget.userData;
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Card(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: post.imageUrl.runtimeType != Null
                    ? GestureDetector(
                        onTap: () async {
                          final likers = await DatabaseService().findLikedUsers(post.id!, post.likedBy!);
                          Navigator.pushNamed(context, '/images_details',
                              arguments: {'post': post, 'userData': userData, 'likers': likers});
                        },
                        child: Image.network(
                          post.imageUrl.toString(),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.network(
                        'https://imgc.allpostersimages.com/img/posters/blizzard_u-L-EYJQK0.jpg?h=550&p=0&w=550&background=ffffff',
                        fit: BoxFit.cover,
                      )),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap: () {
                      DatabaseService().addLike(
                          userData.uid!, post.id!, post.likes!, post.likedBy!);
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    child: Icon(
                      post.likedBy!.contains(userData.uid)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: mainColor,
                    )),
                Text(post.likes.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
