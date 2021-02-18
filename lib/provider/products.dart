import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import './product.dart';
import '../utils/constants.dart';

//Notificador de mudanças. Notifica todos os interessados quando um determinado valor for modificado.
class Products with ChangeNotifier {
  final String _baseUrl =
      '${Constants.BASE_API_URL}/products';
  List<Product> _items = [];

  List<Product> get items => [..._items];
  //retorna uma cópia da lista. (spread). Por questões de segurança.

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get("$_baseUrl.json");
    Map<String, dynamic> data = json.decode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach((productID, productData) {
        _items.add(
          Product(
            id: productID,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ),
        );
      });
      notifyListeners();
    }
    return Future.value();
  }

  //marcar função como assíncrona.
  Future<void> addProduct(Product newProduct) async {
    //espera o retorno de uma função (Future)
    final response = await http.post(
      "$_baseUrl.json",
      //espera um json (o json espera um map, para a conversão).
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
    ); //espera a resposta chegar antes de ir para a próxima linha. Não precisa do then.

    _items.add(
      Product(
          id: json.decode(response.body)['name'],
          title: newProduct.title,
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl),
    );
    //Se alguém chamar esse método, aconteceu um evento.
    notifyListeners(); //É preciso notificar os interessados.
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }
    //retorna o index do 1o elemente que satisfaz a função.
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      //patch: atualização
      await http.patch(
        "$_baseUrl/${product.id}.json",
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    //Para notificar os Listeners apenas quando o id do produto realmente existir.
    if (index >= 0) {
      final product = _items[index];
      final response = await http.delete("$_baseUrl/${product.id}.json");
      //remove no front. (Exclusão otimista)
      _items.remove(product);
      notifyListeners();

      //se der errado ele restaura.
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        //Não lança exceção automaticamente.
        throw HttpException('Ocorreu um erro na exclusão do produto.');
        //lançando a exceção personalizada.
      }
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
