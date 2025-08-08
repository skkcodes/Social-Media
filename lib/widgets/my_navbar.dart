import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MyNavbar extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final VoidCallback onPostPressed;
  


  const MyNavbar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onPostPressed,
  });

  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    

    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: onPostPressed,
        backgroundColor: primary,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(height: 78,
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
        _buildNavItem(CupertinoIcons.house_fill, 0, primary, ),
        _buildNavItem(CupertinoIcons.bubble_left_bubble_right, 1, primary, ),
        const SizedBox(width: 48), // Space for FAB
        _buildNavItem(CupertinoIcons.bell_fill, 2, primary, ),
        _buildNavItem(CupertinoIcons.person_fill, 3, primary, ),
            ],
          ),
        ),
      ),


    );
  }

  Widget _buildNavItem(IconData icon, int index, Color primary) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? primary : Colors.grey.shade500),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
