import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';

//procurar url em firebase -> docs
class Auth with ChangeNotifier {
  //https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
  //https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]

  String _userId;
  String _token;
  DateTime _expireDate;
  Timer _logoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return isAuth ? _userId : null;
  }

  String get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyChWdmisyGlGh_AIDeAy0a313PgBxMLU9o'; //[API_KEY]
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));

    final responseBody = json.decode(response.body);
    if (responseBody["error"] != null) {
      //Lançar exceção
      throw AuthException(responseBody["error"]["message"]);
    } else {
      _token = responseBody["idToken"];
      _userId = responseBody["localId"];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody["expiresIn"]),
        ),
      );

      Store.saveMap('userData', {
        'token': _token,
        'userId': _userId,
        'expireDate': _expireDate.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return Future.value();

    final userData = await Store.getMap('userData');
    if (userData == null) return Future.value();

    final expireDate = DateTime.parse(userData['expireDate']);
    if (expireDate.isBefore(DateTime.now())) return Future.value();

    _userId = userData['userId'];
    _token = userData['token'];
    _expireDate = expireDate;

    _autoLogout();
    notifyListeners();
    return Future.value();
  }

  void logout() {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }
    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_logoutTimer != null) _logoutTimer.cancel();

    final timeToLogout = _expireDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout), logout);
  }
}
