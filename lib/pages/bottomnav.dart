import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:appbooking/pages/home.dart';
import 'package:appbooking/pages/booking.dart';
import 'package:appbooking/pages/profile.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int _selectedIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [Home(), Boooking(), Profile()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.grey.shade900, // Dark background for the navbar
        buttonBackgroundColor: Colors.white, // White button background
        height: 60,
        animationDuration: const Duration(milliseconds: 400),
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.home,
                size: 30,
                color:
                    _selectedIndex == 0
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : Colors
                            .white, // Dark icon when active, white when inactive
              ),
              if (_selectedIndex == 0)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 4,
                  width: 4,
                  decoration: BoxDecoration(
                    color: Colors.white, // White indicator for active tab
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.book_online,
                size: 30,
                color:
                    _selectedIndex == 1
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : Colors
                            .white, // Dark icon when active, white when inactive
              ),
              if (_selectedIndex == 1)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 4,
                  width: 4,
                  decoration: BoxDecoration(
                    color: Colors.white, // White indicator for active tab
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 30,
                color:
                    _selectedIndex == 2
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : Colors
                            .white, // Dark icon when active, white when inactive
              ),
              if (_selectedIndex == 2)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 4,
                  width: 4,
                  decoration: BoxDecoration(
                    color: Colors.white, // White indicator for active tab
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
