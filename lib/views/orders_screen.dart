import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_widget.dart';

class OrdersScreen extends StatelessWidget {

  Future<void> _refreshOrders(BuildContext context){
    return Provider.of<Orders>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Pedidos"),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshOrders(context),
              child: FutureBuilder(
                //quando future retonar, vamos retornar o builder.
                future: Provider.of<Orders>(context, listen: false).loadOrders(),
                builder: (ctx, snapshot){
                  //se estiver esperando.
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  //se der erro.
                  }else if(snapshot.error != null){
                    return Center(child: Text('Ocorreu um erro!'));
                  //quando parar de carregar
                  }else{
                    return Consumer<Orders>(
                      builder: (ctx, orders, child){
                        return ListView.builder(
                          itemCount: orders.itemsCount,
                          itemBuilder: (ctx, i) {
                            return OrderWidget(orders.items[i]);
                          });
                    },
                    );
                  }
                },
              ),
      ),
    );
  }
}
