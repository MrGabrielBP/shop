import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';
import '../data/dummy_data.dart';

//Notificador de mudanças. Notifica todos os interessados quando um determinado valor for modificado.
class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];
  //retorna uma cópia da lista. (spread). Por questões de segurança.

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  void addProduct(Product newProduct) {
    //para criar coleções, adc dps da url /categoria. No Firebase, terminar com .json
    const url =
        'https://flutter-375bc-default-rtdb.firebaseio.com/products.json';
    http.post(
      url,
      //espera um json (o json espera um map, para a conversão).
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
    );
    _items.add(
      Product(
          id: Random().nextDouble().toString(),
          title: newProduct.title,
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl),
    );
    //Se alguém chamar esse método, aconteceu um evento.
    notifyListeners(); //É preciso notificar os interessados.
  }

  void updateProduct(Product product) {
    if (product == null || product.id == null) {
      return;
    }
    //retorna o index do 1o elemente que satisfaz a função.
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);
    //Para notificar os Listeners apenas quando o id do produto realmente existir.
    if (index >= 0) {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }

  int get itemsCount {
    return _items.length;
  }
}

/*
bool _showFavoriteOnly = false;

void showFavoriteOnly() {
  _showFavoriteOnly = true;
  notifyListeners();
}

void showAll() {
  _showFavoriteOnly = false;
  notifyListeners();
}
*/
