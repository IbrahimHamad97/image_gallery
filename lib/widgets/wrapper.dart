import 'package:flutter/material.dart';
import 'package:image_gallery/models/user_model.dart';
import 'package:image_gallery/screens/home_screen.dart';
import 'package:image_gallery/screens/login_screen.dart';
import 'package:image_gallery/screens/signup_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isSignIn = true;

  void changePage() {
    setState(() => isSignIn = !isSignIn);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);
    if (user == null){
      return Scaffold(
          body: isSignIn
              ? LoginScreen(changePage: changePage)
              : SignUpScreen(changePage: changePage));
    }
    return Scaffold(body: HomeScreen());
  }
}
