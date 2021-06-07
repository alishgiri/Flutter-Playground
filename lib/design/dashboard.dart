import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_in_flutter/design/bottom_nav_view/events_calendar.dart';
import 'package:test_in_flutter/design/bottom_nav_view/home.dart';
import 'package:test_in_flutter/design/bottom_nav_view/live_occupant.dart';

class Dashboard extends StatefulWidget {
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  List<Widget> _bodies = [Home(), LiveOccupants(), EventsCalendar()];

  void _setCurrentTap(int i) => setState(() => _currentIndex = i);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final primaryColor = Color.fromRGBO(142, 119, 243, 1);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _currentIndex,
        iconSize: tt.subtitle1.fontSize,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (int index) => _setCurrentTap(index),
        items: [
          BottomNavigationBarItem(
            label: "",
            icon: Icon(FontAwesomeIcons.home),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(FontAwesomeIcons.userClock),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(FontAwesomeIcons.calendarAlt),
          ),
        ],
      ),
      body: SafeArea(child: _bodies[_currentIndex]),
    );
  }
}
