import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/provider/product.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode(); //gerenciar quem vai estar no foco.
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  //Resolve pra gente o estado do formulario para ter acesso ao form.
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    //adicionar um listener para o foco.
    _imageUrlFocusNode.addListener(_updateImageUrl);
    //registrar uma função para ser chamada quando o objeto mudar.
  }

  void _updateImageUrl() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {}); //por ser um controller.
    }
  }

  bool isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');
    return (startWithHttps || startWithHttp) &&
        (endsWithJpeg || endsWithJpg || endsWithPng);
  }

  @override
  void dispose() {
    super.dispose();
    //Liberar uso de memória ao fechar a tela.
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
  }

  void _saveForm() {
    //se o form for válido retorna Verdadeiro.
    bool isValid = _form.currentState.validate();
    if (!isValid) return;
    //vai disparar o onSave em cada dos nossos TextFormField.
    _form.currentState.save();
    final newProduct = Product(
      id: Random().nextDouble().toString(),
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      //Widget para trabalhar com formulários.
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Título'),
                  //mudar ação do enter para mudar para next (textfield).
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    //vai mudar o foco para o próximo textfield ao submeter (next).
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) => _formData['title'] = value,
                  //essa função vai ser chamada quando você disparar a validação no formulário.
                  validator: (value) {
                    bool isEmpty = value.trim().isEmpty;
                    bool isInvalid = value.trim().length < 3;
                    if (isEmpty || isInvalid) {
                      return "Informe um título válido com no mínimo 3 caracteres!";
                    }
                    return null;
                    //retorna nulo quando não há nenhum erro.
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Preço'),
                  focusNode: _priceFocusNode,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) => _formData['price'] = double.parse(value),
                  validator: (value) {
                    bool isEmpty = value.trim().isEmpty;
                    var newPrice = double.tryParse(value);
                    bool isInvalid = newPrice == null || newPrice <= 0;
                    if (isEmpty || isInvalid) {
                      return "Informe um preço válido!";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) => _formData['description'] = value,
                  validator: (value) {
                    bool isEmpty = value.trim().isEmpty;
                    bool isInvalid = value.trim().length < 10;
                    if (isEmpty || isInvalid) {
                      return "Informe uma descrição válida com no mínimo 10 caracteres!";
                    }
                    return null;
                    //retorna nulo quando não há nenhum erro.
                  },
                ),
                //No Form não precisa de controller.
                //Só vai precisar neste caso pra mostrar a imagem preview.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _imageUrlFocusNode,
                        controller: _imageUrlController,
                        decoration: InputDecoration(
                          labelText: 'URL da Imagem',
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) => _formData['imageUrl'] = value,
                        validator: (value) {
                          bool isEmpty = value.trim().isEmpty;
                          bool isInvalid = !isValidImageUrl(value);
                          if (isEmpty || isInvalid) {
                            return "Informe uma URL válida!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 8,
                        left: 10,
                      ),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text("Informe a URL")
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                      alignment: Alignment.center,
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
