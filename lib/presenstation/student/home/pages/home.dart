import 'package:flutter/material.dart';
import 'package:sitama/presenstation/student/guidance/pages/guidance.dart';
import 'package:sitama/presenstation/student/home/widgets/home_content.dart';
import 'package:sitama/presenstation/student/logbook/pages/logbook.dart';
import 'package:sitama/presenstation/student/profile/pages/profile.dart';

/// A stateful widget that serves as the main navigation hub for the student interface.
/// Contains a bottom navigation bar for switching between different sections of the app.
class HomePage extends StatefulWidget {
  /// The initial index for the bottom navigation bar.
  /// Defaults to 0 (Home page).
  final int currentIndex;

  const HomePage({super.key, this.currentIndex = 0});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  /// Tracks the currently selected index in the bottom navigation bar
  late int _currentIndex;
  late PageController _pageController;

  @override
  bool get wantKeepAlive => true;

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
    // List of all pages including HomeContent
    final List<Widget> pages = [
      _buildHomeContent(),
      const GuidancePage(),
      const LogBookPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      // Use PageView.builder for efficient page rendering
      body: PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // Add physics for better scrolling feel
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return pages[index];
        },
      ),
      
      // Custom styled bottom navigation bar with elevation shadow
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.1*255).round()),
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
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurface.withAlpha((0.6*255).round()),
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
        // Animate to guidance page
        _pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      // Callback to navigate to logbook section
      allLogBooks: () {
        // Animate to logbook page
        _pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );
  }
}