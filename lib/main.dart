import 'package:flutter/material.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/views/auth_home_home.dart';
import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/orders_screen.dart';
import 'package:shop/views/product_detail_screen.dart';
import 'package:shop/views/product_form_screen.dart';
import 'package:shop/views/product_screen.dart';
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
          create: (_) => Auth(),
        ),
        //passar o token do provider Auth para cá. Para conseguir pegar dados de outro Provider.
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => new Products(),
          update: (ctx, auth, previousProducts) =>
              Products(auth.token, auth.userId, previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => new Orders(),
          update: (ctx, auth, previousOrders) =>
              Orders(auth.token, previousOrders.items),
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
          AppRoutes.AUTH_HOME: (ctx) => AuthOrHomeScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
