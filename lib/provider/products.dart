import 'package:flutter/material.dart';
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

  void addProduct(Product product) {
    _items.add(product);
    //Se alguém chamar esse método, aconteceu um evento.
    notifyListeners(); //É preciso notificar os interessados.
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
