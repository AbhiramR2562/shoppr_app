import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottumnavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottumnavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
        onTabChange: onTabChange,
        tabs: [
          // SHOP
          const GButton(
            icon: Icons.home,
            text: 'Shop',
            iconSize: 22,
            textSize: 14,
          ),

          // CART
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
