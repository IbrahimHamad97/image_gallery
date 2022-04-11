import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // type: BottomNavigationBarType.fixed,
      // iconSize: 30,
      // indexedstack(index:) for keeping state between pages
      currentIndex: currentIndex,
      onTap: (index) => setState(() {
        currentIndex = index;
      }),
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.red),
        BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "Info",
            backgroundColor: Colors.green),
        BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "ha",
            backgroundColor: Colors.yellow),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "no",
            backgroundColor: Colors.pink),
      ],
    );
  }
}
