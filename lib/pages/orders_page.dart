import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';

import '../components/order_widget.dart';
import '../models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  loadOrders(BuildContext context) {
    Provider.of<OrderList>(context, listen: false).
      loadOrders();    
  }

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    //final OrderList orders = Provider.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshOrders(context),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          
          } else if (snapShot.hasError) {
            return Center(
              child: Text('Ocorreu um erro!')
            );
          } else {
            return Consumer<OrderList>(
              builder: (ctx, orders, child) => ListView.builder(
                itemBuilder: (ctx, i) => OrderWidget(
                  order: orders.items[i]
                ), 
                itemCount: orders.itemsCount,
              )
            );
          }
        }
      ),
      /*body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
          onRefresh: () => _refreshOrders(context), 
          child: ListView.builder(
            itemCount: orders.itemsCount,
            itemBuilder: (ctx, i) => 
              OrderWidget(order: orders.items[i])
          )
        ),*/
    );
  }
}