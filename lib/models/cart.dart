

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  int get itemsCount {
    return _cartItems.length;
  }

  double get totalAmount {
    double total = 0.0;
    _cartItems.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clear() {
    _cartItems = {};
    notifyListeners();
  }

  void addItem(Product product) { 
     
    if (_cartItems.containsKey(product.id)) {    
      _cartItems.update(product.id, 
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          name: existingItem.name,
          quantity: existingItem.quantity + 1,
          price: existingItem.price
        )
      );
    } else {
      print('nao');
      _cartItems.putIfAbsent(product.id, 
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.title,
          quantity: 1,
          price: product.price
        )
      );
    }
    notifyListeners();
  }

}