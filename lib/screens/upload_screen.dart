import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery/firebase/database.dart';
import 'package:image_gallery/firebase/storage.dart';
import 'package:image_gallery/models/user_model.dart';
import 'package:image_gallery/screens/loading_screen.dart';
import 'package:image_gallery/services/shared_items.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class UploadScreen extends StatefulWidget {
  final UserData? userData;

  const UploadScreen({Key? key, this.userData}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool showLoading = true;
  File? image;
  UploadTask? _task;

  Future pickImage(ImageSource source) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final chosenImage = await _picker.pickImage(source: source);
      if (chosenImage == null) return;
      final imageUrl = File(chosenImage.path);
      setState(() {
        image = imageUrl;
      });
    } catch (e) {print(e);}
  }

  void uploadImage(UserData userData) async {
    if (image == null) return;
    setState(() {
      showLoading = true;
    });
    final dest = 'galleryImages/${uuid.v4()}';
    _task = FirebaseStorageApi.uploadFile(dest, image!);
    setState(() {
      image = null;
    });
    if (_task == null) return;
    final snapshot = await _task!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    await DatabaseService().createPost(userData.uid!, userData.userName!,
        urlDownload, 0, FieldValue.serverTimestamp(), []);
    showLoading = false;
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return Container(
                padding: EdgeInsets.symmetric(vertical: 250),
                child: Column(
                  children: [
                    Loading(),
                    SizedBox(height: 20),
                    Text(
                      'Uploading...',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    )
                  ],
                ));
          } else {
            return Container();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final userData = widget.userData;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _task != null
                ? buildUploadStatus(_task!)
                : image != null
                    ? Column(
                        children: [
                          Image.file(image!),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: () {
                                uploadImage(userData!);
                              },
                              child: Text("Upload Image"),
                            ),
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  image = null;
                                });
                              },
                              child: Text("Clear Image"),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              pickImage(ImageSource.gallery);
                            },
                            child: Container(
                              color: secondColor,
                              width: double.maxFinite,
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo_album_outlined,
                                    color: mainColor,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Choose Image",
                                    style: TextStyle(color: mainColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              pickImage(ImageSource.camera);
                            },
                            child: Container(
                              color: secondColor,
                              width: double.maxFinite,
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    color: mainColor,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Take Picture",
                                    style: TextStyle(color: mainColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
          ],
        ),
      ),
    );
  }
}
