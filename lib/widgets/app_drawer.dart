import 'package:flutter/material.dart';
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
                Navigator.of(context).pushReplacementNamed(AppRoutes.HOME),
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
        ],
      ),
    );
  }
}
