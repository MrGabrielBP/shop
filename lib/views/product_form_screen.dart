import 'package:flutter/material.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode(); //gerenciar quem vai estar no foco.
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //adicionar um listener para o foco.
    _imageUrlFocusNode.addListener(_updateImageUrl);
    //registrar uma função para ser chamada quando o objeto mudar.
  }

  void _updateImageUrl() {
    setState(() {}); //por ser um controller.
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
