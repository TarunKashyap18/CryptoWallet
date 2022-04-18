import 'package:crypto_wallet/Screens/explore_page.dart';
import 'package:crypto_wallet/Screens/home.dart';
import 'package:crypto_wallet/screens/profile_page.dart';
import 'package:crypto_wallet/theme/colors.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;
  // final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    // _pageController = PageController(initialPage: _selectedIndex);
  }

  // void onPageChanged(int page) {
  //   setState(() {
  //     _selectedIndex = page;
  //   });
  // }

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // _pageController.animateToPage(index,
    //     duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          Home(),
          ExplorePage(),
          ProfilePage(),
        ],
      ),
      // PageView(
      //   physics: const NeverScrollableScrollPhysics(),
      //   onPageChanged: onPageChanged,
      //   controller: _pageController,
      //   children: const [
      //     Home(),
      //     ExplorePage(),
      //     ProfilePage(),
      //   ],
      // ),
      bottomNavigationBar: CustomNavigationBar(
        iconSize: 30.0,
        selectedColor: const Color(0xff040307),
        strokeColor: const Color(0x30040307),
        unSelectedColor: const Color.fromARGB(255, 211, 210, 210),
        backgroundColor: primary.withOpacity(0.9),
        // borderRadius: const Radius.circular(10),
        // isFloating: true,
        items: [
          CustomNavigationBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.lightbulb_outline),
            title: const Text("Explore"),
          ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            title: const Text("Me"),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
