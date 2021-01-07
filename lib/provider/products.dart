import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_data.dart';

//Notificador de mudanças. Notifica todos os interessados quando um determinado valor for modificado.
class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items {
    return [..._items];
    //retorna uma cópia da lista. (spread). Por questões de segurança.
  }

  void addProduct(Product product) {
    _items.add(product);
    //Se alguém chamar esse método, aconteceu um evento.
    notifyListeners(); //É preciso notificar os interessados.
  }
}
