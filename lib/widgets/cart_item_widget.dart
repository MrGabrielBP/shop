import 'package:flutter/material.dart';
import 'package:shop/provider/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  CartItemWidget(this.cartItem);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FittedBox(
                child: Text(
                  'R\$${cartItem.price}',
                  style: TextStyle(
                      color:
                          Theme.of(context).primaryTextTheme.headline6.color),
                ),
              ),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text('Total: R\$${cartItem.price * cartItem.quantity}'),
          trailing: Text('${cartItem.quantity}x'),
        ),
      ),
    );
  }
}
