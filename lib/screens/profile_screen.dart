import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery/firebase/database.dart';
import 'package:image_gallery/firebase/storage.dart';
import 'package:image_gallery/models/user_model.dart';
import 'package:image_gallery/screens/loading_screen.dart';
import 'package:image_gallery/screens/upload_screen.dart';
import 'package:image_gallery/services/shared_items.dart';
import 'package:image_gallery/widgets/images_display.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final UserData? userData;
  final posts;

  const ProfileScreen({Key? key, this.userData, this.posts}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  UploadTask? _task;
  bool loading = false;

  Future pickImage(ImageSource source) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final chosenImage = await _picker.pickImage(source: source);
      if (chosenImage == null) return;
      final imageUrl = File(chosenImage.path);
      setState(() {
        image = imageUrl;
      });
    } catch (e) {}
  }

  void uploadImage(uid) async {
    if (image == null) return;
    setState(() {
      loading = true;
    });
    final dest = 'galleryImages/${uuid.v4()}';
    _task = FirebaseStorageApi.uploadFile(dest, image!);
    if (_task == null) return;
    try {
      final snapshot = await _task!.whenComplete(() => {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      await DatabaseService(uid: uid).updateUserImage(urlDownload);
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.userData;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await pickImage(ImageSource.gallery);
                },
                child: loading
                    ? Loading()
                    : Stack(
                        children: [
                          ClipOval(
                            child: userData!.profilePic != '' && image == null
                                ? Image.network(
                                    userData.profilePic ?? '',
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  )
                                : image == null && userData.profilePic == ''
                                    ? Image.asset('assets/night_bg.png',
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.fill)
                                    : Image.file(
                                        image!,
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 20,
                              child: Container(
                                child: Icon(
                                  Icons.edit,
                                  color: mainColor,
                                ),
                              )),
                        ],
                      ),
              ),
              SizedBox(height: 10),
              Text(
                userData!.userName ?? '',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: mainColor),
              ),
              SizedBox(height: 10),
              image != null
                  ? ElevatedButton(
                      onPressed: () {
                        uploadImage(userData.uid);
                        setState(() {
                          image = null;
                        });
                      },
                      child: Text("Update Image"))
                  : Container(),
              Divider(),
              ImagesDisplay(
                  isRecent: true,
                  posts: widget.posts,
                  currentUser: userData,
                  userData: userData)
            ],
          ),
        ),
      ),
    );
  }
}
