import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart_item.dart';

import '../utils/constants.dart';
import 'cart.dart';
import 'order.dart';

class OrderList with ChangeNotifier {
  final String _token;
  List<Order> _items = [];

  OrderList([this._token = '', this._items = const []]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    var uriOrder = Uri.parse('${Constants.ORDER_BASE_URL}.json?auth=$_token');

    var firebaseCart = jsonEncode({
      "total": cart.totalAmount,
      "date": date.toIso8601String(), 
      "products": cart.cartItems.values.map((itemMap) => {
        "id": itemMap.id, 
        "productId": itemMap.productId, 
        "name": itemMap.name,
        "quantity": itemMap.quantity, 
        "price": itemMap.price
      }).toList()
    });

    final response = await http.post(
      uriOrder,
      body: firebaseCart
    );

    if ((response.statusCode >= 400) == false) {

      final id = jsonDecode(response.body)['name'];
       
      _items.insert(
        0, 
        Order(
          id: id,//Random().nextDouble().toString(), 
          total: cart.totalAmount, 
          products: cart.cartItems.values.toList(), 
          date: date
        )
      );

      notifyListeners();
    }
  }

  convertProductsOrder(List<dynamic> products) {
    return products.map((item) {
      return CartItem(id: item['id'], productId: item['productId'], name: item['name'], quantity: item['quantity'], price: item['price']);
    }).toList();
  }

  Future<void> loadOrders() async {
    List<Order> items = [];

    final response = await http.get(Uri.parse('${Constants.ORDER_BASE_URL}.json?auth=$_token'));

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((orderId, orderData) {
      items.add(
        Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],
          products: convertProductsOrder(orderData['products']),
        )
      );
    });

    _items = items.reversed.toList();//reversed = pedidos mais novos acima

    notifyListeners();
  }

}