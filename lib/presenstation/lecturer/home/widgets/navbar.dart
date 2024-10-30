import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationBarWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: currentIndex == 0 ? AppColors.primary : Colors.grey),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: currentIndex == 1 ? AppColors.primary : Colors.grey),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
