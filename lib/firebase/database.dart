import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_gallery/models/post_model.dart';
import 'package:image_gallery/models/user_model.dart';

class DatabaseService {
  late String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  UserData _createUserData(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      userName: snapshot['userName'],
      email: snapshot['email'],
      profilePic: snapshot['profilePic'],
      role: snapshot['role'],
    );
  }

  Future updateUserData(
      String userName, String email, String profilePic, String role) async {
    return await userCollection.doc(uid).set({
      'id': uid,
      'userName': userName,
      'email': email,
      'profilePic': profilePic,
      'role': role
    });
  }

  Future updateUserImage(String profilePic) async {
    return await userCollection.doc(uid).update({
      'profilePic': profilePic,
    });
  }

  Future addLike(String id, String pid, int likes, List likedBy) async {
    final post = await postsCollection.doc(pid).get();
    final dynamic data = post.data();
    List? likedBy = data['likedBy'];
    if (likedBy!.isNotEmpty) {
        if (likedBy.contains(id)) {
          likes = likes - 1;
          likedBy = likedBy.where((element) => element != id).toList();
          await postsCollection.doc(pid).update({'likedBy': likedBy, 'likes': likes});
        } else {
          likes = likes + 1;
          likedBy.add(id);
          await postsCollection.doc(pid).update({'likedBy': likedBy, 'likes': likes});
        }
    }
    else {
      likes = likes + 1;
      likedBy.add(id);
      await postsCollection.doc(pid).update({'likedBy': likedBy, 'likes': likes});
    }
  }

  Future createPost(String owner, String ownerUsername, String imageUrl,
      int likes, FieldValue createdAt, List likedBy) async {
    final result = await postsCollection.add({
      'owner': owner,
      'ownerUsername': ownerUsername,
      'imageUrl': imageUrl,
      'likes': likes,
      'createdAt': createdAt,
      'likedBy': likedBy
    });
    await postsCollection.doc(result.id).update({'id': result.id});
    return result;
  }

  List<PostData> _postsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PostData(
        owner: doc.get('owner') ?? '',
        ownerUsername: doc.get('ownerUsername') ?? '',
        imageUrl: doc.get('imageUrl') ?? '0',
        likes: doc.get('likes') ?? 0,
        createdAt: doc.get('createdAt'),
        id: doc.get('id') ?? '',
        likedBy: doc.get('likedBy'),
      );
    }).toList();
  }

  List<UserData> _usersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserData(
          uid: doc.get('id') ?? '',
          userName: doc.get('userName') ?? '',
          email: doc.get('email') ?? '',
          profilePic: doc.get('profilePic') ?? '0',
          role: doc.get('role') ?? '');
    }).toList();
  }

  Future deletePost(String id) async {
    await postsCollection.doc(id).delete();
  }

  Future<List> findLikedUsers(String pid, List likedBy) async {
    List likers = [];
    if (likedBy.isNotEmpty){
      for (int i = 0; i < likedBy.length; i++){
        final value = await userCollection.doc(likedBy[i]).get();
        final dynamic info = value.data();
        likers.add(info);
      }
      return likers;
    }
    else {
      return likers;
    }
  }

  Stream<List<PostData>> get posts {
    return postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_postsListFromSnapshot);
  }

  Stream<List<PostData>> get postsByLikes {
    return postsCollection
        .orderBy('likes', descending: true)
        .snapshots()
        .map(_postsListFromSnapshot);
  }

  Stream<List<UserData>> get users {
    return userCollection.snapshots().map(_usersListFromSnapshot);
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_createUserData);
  }
}
