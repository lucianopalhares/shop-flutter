import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../utils/constants.dart';

class ProductList with ChangeNotifier {
  String _token;
  List<Product> _items = [];//dummyProducts; 

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items.where((prod) => prod.isFavorite).toList();

  ProductList(this._token, this._items);

  int get itemsCount {
    return _items.length;
  }

  Future<void> addProduct(Product product) async {
    var uriProduct = Uri.parse('${Constants.PRODUCT_BASE_URL}.json');

    var firebaseProduct = jsonEncode({
      "name": product.name,
      "description": product.description,
      "price": product.price,
      "imageUrl": product.imageUrl,
      "isFavorite": product.isFavorite,
    });

    final response = await http.post(
      uriProduct,
      body: firebaseProduct
    ).catchError((error) {
      throw error;
    });

      if (response.statusCode != 200) {
        throw(response.body);
      }

      final id = jsonDecode(response.body)['name'];
      
      final newProduct = Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite
      );
      _items.add(newProduct);
      notifyListeners();
   
  }

  Future<void> updateProduct(Product product) async{

    int index = _items.indexWhere((el) => el.id == product.id);

    if (index >=0) {

      var uriProduct = Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json');

      var firebaseProduct = jsonEncode({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
        //"isFavorite": product.isFavorite,
      });

      final response = await http.patch(
        uriProduct,
        body: firebaseProduct
      ).catchError((error) {
        throw error;
      });

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(Product product) async {
    
    int index = _items.indexWhere((el) => el.id == product.id);

    if (index >=0) {

      final product = _items[index];
      _items.remove(product);

      var uriProduct = Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json');

      var firebaseProduct = jsonEncode({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
        //"isFavorite": product.isFavorite,
      });

      final response = await http.delete(
        uriProduct
      ).catchError((error) {
        throw error;
      });

      if (response.statusCode >= 400) {
     
        _items.insert(index, product);

        throw HttpException(
          msg: 'Nao foi possivel excluir o produto',
          statusCode: response.statusCode 
        );
      }

      //_items.removeWhere((el) => el.id == product.id);

      notifyListeners();
    }


  }

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(Uri.parse('${Constants.PRODUCT_BASE_URL}.json'));

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite']
        )
      );
    });

    notifyListeners();
  }

  Future<void> saveProductForm(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final productForm = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(), 
      name: data['name'] as String, 
      description: data['description'] as String, 
      price: data['price'] as double, 
      imageUrl: data['imageUrl'] as String
    );

    if (hasId) {
      return updateProduct(productForm);
    } else {
      return addProduct(productForm);
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