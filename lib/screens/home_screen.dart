import 'package:flutter/material.dart';
import 'package:image_gallery/firebase/auth.dart';
import 'package:image_gallery/firebase/database.dart';
import 'package:image_gallery/models/post_model.dart';
import 'package:image_gallery/models/user_model.dart';
import 'package:image_gallery/screens/profile_screen.dart';
import 'package:image_gallery/screens/search_screen.dart';
import 'package:image_gallery/screens/upload_screen.dart';
import 'package:image_gallery/services/shared_items.dart';
import 'package:image_gallery/widgets/images_display.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final AuthServices _auth = AuthServices();
  int currentIndex = 0;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);
    // final route = ModalRoute.of(context)!.settings.name;
    return StreamBuilder<List<PostData>>(
      stream: DatabaseService().postsByLikes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.hasData) {
          List<PostData> likedPosts = snapshot.data!;
          return StreamBuilder<List<PostData>>(
              stream: DatabaseService().posts,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                if (snapshot.hasData) {
                  List<PostData> posts = snapshot.data!;
                  return StreamBuilder<UserData?>(
                      stream: DatabaseService(uid: user!.uid).userData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          UserData userData = snapshot.data!;
                          return Scaffold(
                            appBar: appBar(user),
                            body: IndexedStack(
                              index: currentIndex,
                              children: [
                                TabBarView(
                                    controller: tabController,
                                    children: [
                                      ImagesDisplay(
                                          isRecent: true,
                                          posts: posts,
                                          userData: userData),
                                      ImagesDisplay(
                                          isRecent: false,
                                          posts: likedPosts,
                                          userData: userData)
                                    ]),
                                UploadScreen(userData: userData),
                                SearchScreen(posts: posts, userData: userData),
                                ProfileScreen(userData: userData, posts: posts),
                              ],
                            ),
                            bottomNavigationBar: bottomNavBar(),
                          );
                        } else {
                          return Container();
                        }
                      });
                } else {
                  return Container();
                }
              });
        } else {
          return Container();
        }
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return StreamProvider<UserData?>.value(
  //     value: DatabaseService().userData,
  //     initialData: null,
  //     catchError: (_, __) => null,
  //     child: Scaffold(
  //       appBar: appBar(),
  //       body: currentIndex == 0
  //           ? TabBarView(controller: tabController, children: [
  //               ImagesDisplay(isRecent: true),
  //               ImagesDisplay(isRecent: false)
  //             ])
  //           : currentIndex == 1
  //               ? UploadScreen()
  //               : currentIndex == 2
  //                   ? SearchScreen()
  //                   : currentIndex == 3
  //                       ? ProfileScreen()
  //                       : Container(),
  //       bottomNavigationBar: bottomNavBar(),
  //     ),
  //   );
  // }

  appBar(user) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await _auth.logOut();
          }),
      // user != null
      //     ? IconButton(
      //         icon: Icon(Icons.logout),
      //         onPressed: () async {
      //           await _auth.logOut();
      //         })
      //     : IconButton(
      //         icon: Icon(Icons.account_circle),
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/login');
      //         }),
      title: currentIndex == 0
          ? Text("Home")
          : currentIndex == 1
              ? Text("Search")
              : currentIndex == 2
                  ? Text("Something")
                  : currentIndex == 3
                      ? Text("Profile")
                      : Container(),
      centerTitle: true,
      actions: [
        // IconButton(icon: Icon(Icons.wb_sunny_outlined), onPressed: () {}),
      ],
      bottom: currentIndex == 0
          ? TabBar(
              controller: tabController,
              isScrollable: false,
              unselectedLabelColor: Colors.white.withOpacity(0.3),
              indicatorColor: Colors.white,
              tabs: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Recent",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Popular",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          : null,
    );
  }

  imageGrid() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: GridView.builder(
          itemCount: 3,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return Container(child: Image(image: AssetImage('assets/A2.png')));
          }),
    );
  }

  bottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: secondColor,
      elevation: 0,
      currentIndex: currentIndex,
      showUnselectedLabels: false,
      showSelectedLabels: true,
      selectedItemColor: mainColor,
      unselectedItemColor: mainColor,
      // backgroundColor: Colors.yellow[400],
      onTap: (index) => setState(() {
        currentIndex = index;
      }),
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), label: "Home", backgroundColor: Colors.red),
        BottomNavigationBarItem(
            icon: Icon(Icons.upload_rounded),
            label: "Upload",
            backgroundColor: Colors.green),
        BottomNavigationBarItem(
            icon: Icon(Icons.search_off_rounded),
            label: "Search",
            backgroundColor: Colors.yellow),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
            backgroundColor: Colors.pink),
      ],
    );
  }

  notLoggedInBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: secondColor,
      elevation: 0,
      currentIndex: currentIndex,
      showUnselectedLabels: false,
      showSelectedLabels: true,
      selectedItemColor: mainColor,
      unselectedItemColor: mainColor,
      // backgroundColor: Colors.yellow[400],
      onTap: (index) => setState(() {
        currentIndex = index;
      }),
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), label: "Home", backgroundColor: Colors.red),
        BottomNavigationBarItem(
            icon: Icon(Icons.search_off_rounded),
            label: "Search",
            backgroundColor: Colors.yellow),
      ],
    );
  }
}
