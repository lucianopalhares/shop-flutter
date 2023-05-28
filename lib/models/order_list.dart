import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'cart.dart';
import 'order.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    var uriOrder = Uri.parse('${Constants.ORDER_BASE_URL}.json');

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
}