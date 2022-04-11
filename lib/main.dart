import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery/firebase/auth.dart';
import 'package:image_gallery/models/user_model.dart';
import 'package:image_gallery/screens/image_details.dart';
import 'package:image_gallery/screens/user_screen.dart';
import 'package:image_gallery/services/shared_items.dart';
import 'package:image_gallery/widgets/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData?>.value(
        value: AuthServices().user,
        initialData: null,
        catchError: (_, __) => null,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Image Gallery',
            debugShowCheckedModeBanner: false,
            theme: Themes.light,
            darkTheme: Themes.light,
            initialRoute: "/",
            routes: {
              "/": (context) => Wrapper(),
              "/images_details": (context) => ImageDetails(),
              "/user_details": (context) => UserScreen(),
            },
          );
        });
  }
}
