import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shop/provider/product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItems(Product product) {
    //Caso já tenha, manter e aumentar a quantidade.
    if (_items.containsKey(product.id)) {
      //Recebe um item antigo e atualiza ele.
      _items.update(product.id, (oldItem) {
        return CartItem(
          id: oldItem.id,
          productId: product.id,
          title: oldItem.title,
          quantity: oldItem.quantity + 1,
          price: oldItem.price,
        );
      });
    } else {
      //Vai incluir se não estiver presente.
      _items.putIfAbsent(
          product.id,
          () => CartItem(
                id: Random().nextDouble().toString(),
                productId: product.id,
                title: product.title,
                quantity: 1,
                price: product.price,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
