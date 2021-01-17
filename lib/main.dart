import 'package:flutter/material.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/views/cart_screens.dart';
import 'package:shop/views/product_detail_screen.dart';
import './views/products_overview_screen.dart';
import './utils/app_routes.dart';
import 'package:provider/provider.dart';
import './provider/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Usar múltiplos providers.
    return MultiProvider(
      providers: [
        //instanciar os produtos.
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
        },
        home: ProductOverViewScreen(),
      ),
    );
  }
}
