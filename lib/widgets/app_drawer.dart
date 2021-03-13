import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Bem vindo Usário"),
            automaticallyImplyLeading: false, //Remove o icone do drawer
          ),
          Divider(), //linha horizontal
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Loja'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_HOME),
          ),
          Divider(), //linha horizontal
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pedidos'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.ORDERS),
          ),
          Divider(), //linha horizontal
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Gerenciar Produtos'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.PRODUCTS),
          ),
          Divider(), //linha horizontal
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
              })
        ],
      ),
    );
  }
}
