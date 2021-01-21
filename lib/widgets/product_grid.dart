import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
import 'product_grid_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;
  ProductGrid(this.showFavoriteOnly);
  @override
  Widget build(BuildContext context) {
    //Listener
    final productsProvider = Provider.of<Products>(context);
    final products = showFavoriteOnly
        ? productsProvider.favoriteItems
        : productsProvider.items;

    return products.isEmpty
        ? Center(
            child: Text("Não há produtos marcados como favorito."),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            //Instancia Product() já existe. Usar o Provider com .value:
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductGridItem(),
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
