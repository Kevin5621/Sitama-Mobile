import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/content.dart';
import 'package:sistem_magang/presenstation/lecturer/profile/pages/lecturer_profile.dart';

/// A stateful widget that serves as the main navigation hub for the lecturer interface.
/// Contains a bottom navigation bar for switching between different sections of the app.
class LecturerHomePage extends StatefulWidget {
  /// The initial index for the bottom navigation bar.
  /// Defaults to 0 (Home page).
  final int currentIndex;

  const LecturerHomePage({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  State<LecturerHomePage> createState() => _LecturerHomePageState();
}

class _LecturerHomePageState extends State<LecturerHomePage> {
  /// Tracks the currently selected index in the bottom navigation bar
  late int _currentIndex;

  /// List of pages that can be displayed based on navigation
  final List<Widget> _pages = [
    const LecturerHomeContent(),
    const LecturerProfilePage(),
  ];

  @override
  void initState() {
    // Notification pop up premission
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
    // Initialize the current index with the value passed to the widget
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                icon: Icon(_currentIndex == 1 ? Icons.person : Icons.person_outlined),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}