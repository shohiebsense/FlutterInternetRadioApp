import 'package:flutter/material.dart';
import 'package:internet_radio_app/pages/fav_radio_page.dart';
import 'package:internet_radio_app/pages/radio_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [new RadioPage(isFavoriteOnly: false,), new FavRadioPage()];

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xff182545),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          currentIndex: _currentIndex,
          items: [
            _bottomNavItem(Icons.play_arrow, "Listen"),
            _bottomNavItem(Icons.favorite, "Favorites")
          ],
          onTap: onTabTapped),
    ));
  }

  _bottomNavItem(IconData icon, String title) {
    return BottomNavigationBarItem(
        icon: new Icon(icon, color: Color(0xff7C7C7C)),
        label: title,
        activeIcon: new Icon(
          icon,
          color: Color(0xffffffff),
        ),

    );
  }

  void onTabTapped(int index) {
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
    });
  }
}
