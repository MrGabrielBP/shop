import 'package:flutter/material.dart';
import 'package:shop/provider/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop/utils/constants.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  final _baseUrl = '${Constants.BASE_API_URL}/orders';
  List<Order> _items = [];
  String _token;
  String _userId;
  Orders([this._token, this._userId, this._items = const []]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];
    final response = await http.get("$_baseUrl/$_userId.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);
    //Dar print para visualizar a response!!!
    if (data != null) {
      data.forEach((orderID, orderData) {
        loadedItems.add(
          Order(
              id: orderID,
              total: orderData['total'],
              date: DateTime.parse(orderData['date']),
              products: (orderData['products'] as List<dynamic>).map((item) {
                return CartItem(
                  id: item['id'],
                  productId: item['productId'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                );
              }).toList()),
        );
      });
      notifyListeners();
    }
    _items = loadedItems.reversed.toList();
    return Future.value();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      '$_baseUrl/$_userId.json?auth=$_token',
      body: json.encode({
        'total': cart.totalAmount,
        //é um formato padrão para o firebase (facilita para recuperar)
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList()
      }),
    );

    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }
}
