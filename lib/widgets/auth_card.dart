import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import '../provider/auth.dart';

enum AuthMode {
  SignUp,
  Login,
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  //Usado para controlar o estado do Form (chamar as validações ...).
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Ocorreu um erro!"),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) return;

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        // Login
        await auth.login(_authData['email'], _authData['password']);
      } else {
        // Registro
        await auth.signUp(_authData['email'], _authData['password']);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog("Ocorreu um erro inesperado!");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: deviceSize.width * 0.75,
        height: _authMode == AuthMode.Login ? 290 : 330,
        child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['email'] = value,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 8) {
                      return 'Informe uma senha válida';
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['password'] = value,
                ),
                if (_authMode == AuthMode.SignUp)
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.SignUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Senhas são diferentes';
                            }
                            return null;
                          }
                        : null,
                  ),
                Spacer(),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(
                        _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryTextTheme.button.color,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                    ),
                    onPressed: _submit,
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      'ALTERNAR P/ ${_authMode == AuthMode.Login ? 'REIGISTRAR' : 'LOGIN'}'),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
