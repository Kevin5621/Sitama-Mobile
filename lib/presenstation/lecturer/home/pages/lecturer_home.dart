import 'package:flutter/material.dart';
import 'package:Sitama/presenstation/lecturer/home/widgets/common/content.dart';
import 'package:Sitama/presenstation/lecturer/profile/pages/lecturer_profile.dart';

/// A stateful widget that serves as the main navigation hub for the lecturer interface.
/// Contains a bottom navigation bar for switching between different sections of the app.
class LecturerHomePage extends StatefulWidget {
  /// The initial index for the bottom navigation bar.
  /// Defaults to 0 (Home page).
  final int currentIndex;

  const LecturerHomePage({super.key, this.currentIndex = 0});

  @override
  State<LecturerHomePage> createState() => _LecturerHomePageState();
}

class _LecturerHomePageState extends State<LecturerHomePage> with AutomaticKeepAliveClientMixin{
  /// Tracks the currently selected index in the bottom navigation bar
  late int _currentIndex;
  late PageController _pageController;

  @override
  bool get wantKeepAlive => true;

  /// List of pages that can be displayed based on navigation
  final List<Widget> _pages = [
    const LecturerHomeContent(),
    const LecturerProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the current index with the value passed to the widget
    _currentIndex = widget.currentIndex;
  // Initialize PageController with initial page
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    // Dispose the PageController when the widget is disposed
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
     return Scaffold(
      // Use PageView.builder for efficient page rendering
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // Add physics for better scrolling feel
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _pages[index];
        },
      ),

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
              // Animate to the selected page when tapping bottom nav items
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
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