import 'package:flutter/material.dart';
import 'package:shop/provider/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  ProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        //Espera receber um ImageProvider. Para alterações e tals.
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
