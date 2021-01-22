import 'package:flutter/material.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode(); //gerenciar quem vai estar no foco.
  final _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    //Liberar uso de memória ao fechar a tela.
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
      ),
      //Widget para trabalhar com formulários.
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
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
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Preço'),
              focusNode: _priceFocusNode,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocusNode,
            ),
          ],
        )),
      ),
    );
  }
}
