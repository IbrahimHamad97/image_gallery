import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_gallery/models/user_model.dart';
import 'package:image_gallery/firebase/database.dart';

class AuthServices extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Rx<User?> _firebaseUser = Rx<User>();
  //
  // String? get user => _firebaseUser.value.email;
  //
  // @override
  // void onInit() {
  //   _firebaseUser.bindStream(_auth.authStateChanges);
  // }

  UserData? _makeUser(User user) {
    return user != null ? UserData(uid: user.uid) : null;
  }

  Stream<UserData?> get user {
    return _auth.authStateChanges().map((User? user) => _makeUser(user!));
  }

  Future regWithEmailPassword(String email, String password, String userName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseService(uid: user!.uid).updateUserData(userName, email, "", 'member');
      return _makeUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future logInEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _makeUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
