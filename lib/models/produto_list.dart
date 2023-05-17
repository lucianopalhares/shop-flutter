import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts; 

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items.where((prod) => prod.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    int index = _items.indexWhere((el) => el.id == product.id);

    if (index >=0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(Product product) {
    _items.removeWhere((el) => el.id == product.id);

    notifyListeners();
  }

  void saveProductForm(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final productForm = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(), 
      title: data['title'] as String, 
      description: data['description'] as String, 
      price: data['price'] as double, 
      imageUrl: data['imageUrl'] as String
    );

    if (hasId) {
      updateProduct(productForm);
    } else {
      addProduct(productForm);
    }
  }
}

/*
  List<Product> _items = dummyProducts; 
  bool _showFavoriteOnly = false;

  List<Product> get items {
    if (_showFavoriteOnly) {
      return _items.where((prod) => prod.isFavorite).toList();
    }
    return [..._items];
  }

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
  */