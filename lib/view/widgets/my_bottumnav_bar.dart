import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottumnavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  final int cartItemCount;
  MyBottumnavBar({
    super.key,
    required this.onTabChange,
    required this.cartItemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // ← control the total height here
      color: Colors.black,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ), // inner padding
      child: GNav(
        gap: 8, // space between icon and text
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ), // padding inside each tab
        color: Colors.grey[400],
        activeColor: Colors.black,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade100,
        tabBorderRadius: 18,
        mainAxisAlignment: MainAxisAlignment.center,
        onTabChange: onTabChange, // ← don’t forget to call your passed function
        tabs: [
          const GButton(
            icon: Icons.home,
            text: 'Shop',
            iconSize: 22, // ← adjust icon size
            textSize: 14, // ← control text size if needed
          ),
          GButton(
            icon: Icons.shopping_bag_rounded,
            text: 'Cart',
            iconSize: 22,
            textSize: 14,
          ),
        ],
      ),
    );
  }
}
