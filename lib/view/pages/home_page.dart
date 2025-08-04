import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppr/view/pages/cart_page.dart';
import 'package:shoppr/view/pages/products_page.dart';
import 'package:shoppr/view/widgets/my_bottumnav_bar.dart';
import 'package:shoppr/view_model/cart_page/bloc/cart_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bottomBar index controller
  int _selectedIndex = 0;

  // Update selected index
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [ProductsPage(), CartPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return MyBottumnavBar(
            onTabChange: (index) => navigateBottomBar(index),
          );
        },
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
    );
  }
}
