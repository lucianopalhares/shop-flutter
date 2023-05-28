import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';

import '../components/order_widget.dart';
import '../models/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadOrders();
  }

  loadOrders() {
      Provider.of<OrderList>(context, listen: false).
      loadOrders().then((value) {
        setState(() {
          _isLoading = false;
        });   
      });
    
  }

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
          onRefresh: () => _refreshOrders(context), 
          child: ListView.builder(
            itemCount: orders.itemsCount,
            itemBuilder: (ctx, i) => 
              OrderWidget(order: orders.items[i])
          )
        ),
    );
  }
}