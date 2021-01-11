import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Listener
    final productsProvider = Provider.of<Products>(context);
    final products = productsProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        create: (_) => products[i],
        child: ProductItem(),
      ),
      //Itens terão tamanho fixo.
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //Quatidade por linha.
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
