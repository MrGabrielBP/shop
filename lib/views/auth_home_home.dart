import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/views/auth_screen.dart';
import 'package:shop/views/products_overview_screen.dart';

//decidir se vai mostrar um ou outro.
class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    // return auth.isAuth ? ProductOverViewScreen() : AuthScreen();
    return FutureBuilder(
      //tipo um switch com os estados do Future.
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro'));
        } else {
          return auth.isAuth ? ProductOverViewScreen() : AuthScreen();
        }
      },
    );
  }
}
