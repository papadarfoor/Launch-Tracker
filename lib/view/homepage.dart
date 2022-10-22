import 'package:flutter/material.dart';
import 'next_launch_countdown.dart';
import 'favorites.dart';
import 'launches.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final tabs = [const Countdown(), const UpcomingLaunches(), const Favorites()];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.av_timer_outlined,
              ),
              label: 'Next Launch',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.rocket_launch_outlined,
              ),
              label: 'Launches',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_outlined,
              ),
              label: 'Favorites',
            ),
          ],
          selectedItemColor: Colors.black,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        body: tabs[currentIndex],
      ),
    );
  }
}