import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppr/data/repositories/product_repository.dart';
import 'package:shoppr/view/pages/home_page.dart';
import 'package:shoppr/view_model/cart_page/bloc/cart_bloc.dart';
import 'package:shoppr/view_model/product_page/bloc/products_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductsBloc(repository: ProductRepository()),
        ),
        BlocProvider(create: (_) => CartBloc()),
        // Add other BLoCs like ProductsBloc here
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SHOPPR",
      home: HomePage(),
    );
  }
}
