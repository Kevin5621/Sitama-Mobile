import 'package:flutter/material.dart';
import 'package:sistem_magang/presenstation/student/guidance/pages/guidance.dart';
import 'package:sistem_magang/presenstation/student/home/widgets/home_content.dart';
import 'package:sistem_magang/presenstation/student/logbook/pages/logbook.dart';
import 'package:sistem_magang/presenstation/student/profile/pages/profile.dart';

/// A stateful widget that serves as the main navigation hub for the student interface.
/// Contains a bottom navigation bar for switching between different sections of the app.
class HomePage extends StatefulWidget {
  /// The initial index for the bottom navigation bar.
  /// Defaults to 0 (Home page).
  final int currentIndex;

  const HomePage({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Tracks the currently selected index in the bottom navigation bar
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // Initialize the current index with the value passed to the widget
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    // List of pages that can be displayed based on navigation
    final List<Widget> _pages = [
      const GuidancePage(),
      const LogBookPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      // Show HomeContent for index 0, otherwise show corresponding page from _pages
      body: _currentIndex == 0 
          ? _buildHomeContent() 
          : _pages[_currentIndex - 1],
      
      // Custom styled bottom navigation bar with elevation shadow
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          // Rounded corners for the navigation bar
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            elevation: 0,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(_currentIndex == 1 ? Icons.school : Icons.school_outlined),
                label: 'Bimbingan',
              ),
              BottomNavigationBarItem(
                icon: Icon(_currentIndex == 2 ? Icons.book : Icons.book_outlined),
                label: 'Log book',
              ),
              BottomNavigationBarItem(
                icon: Icon(_currentIndex == 3 ? Icons.person : Icons.person_outlined),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the home content with navigation callbacks for guidance and logbook sections
  Widget _buildHomeContent() {
    return HomeContent(
      // Callback to navigate to guidance section
      allGuidances: () {
        setState(() {
          _currentIndex = 1;
        });
      },
      // Callback to navigate to logbook section
      allLogBooks: () {
        setState(() {
          _currentIndex = 2;
        });
      },
    );
  }
}