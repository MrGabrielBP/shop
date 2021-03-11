import 'package:flutter/material.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/product.dart';
import '../utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //false: não vai ser notificado a partir desse product.
    final Product product = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final Auth auth = Provider.of(context, listen: false);
    //RoundedRectangle
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(AppRoutes.PRODUCT_DETAIL, arguments: product),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          /* O Consumer é um widget, então você pode colocar ele exatamente no ponto que
          vc quer na árvore. Perceba que única coisa que muda é o ícone do favorito.
          Só vai redenrizar essa parte. */
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () => product.toggleFavorite(auth.token, auth.userId),
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
              //Acessa o Scaffold pelo contexto e mostra uma snackbar.
              Scaffold.of(context).showSnackBar(
                SnackBar(
                    content: Text('Produto adicionado com sucesso!'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'DESFAZER',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    )),
              );
              cart.addItems(product);
            },
          ),
        ),
      ),
    );
  }
}
