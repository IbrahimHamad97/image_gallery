import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  final String? owner;
  final String? ownerUsername;
  final String? imageUrl;
  final int? likes;
  final Timestamp? createdAt;
  final String? id;
  final List? likedBy;

  PostData(
      {this.owner,
      this.ownerUsername,
      this.imageUrl,
      this.likes,
      this.createdAt,
      this.id,
      this.likedBy});
}
