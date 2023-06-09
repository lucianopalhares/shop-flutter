import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id, 
    required this.name,
    required this.description, 
    required this.price, 
    required this.imageUrl, 
    this.isFavorite = false,
  });

  get isFavorited => isFavorite;

  Future<void> toggleFavorite(BuildContext context, token, userId) async {
    bool isFavoriteChanged = !isFavorite;

    try {
      var uriProduct = Uri.parse('${Constants.USER_FAVORITE_URL}/$userId/${id}.json?auth=$token');

      var firebaseProduct = jsonEncode(isFavoriteChanged);

      final response = await http.put(
        uriProduct,
        body: firebaseProduct
      );

      if ((response.statusCode >= 400) == false) {
        isFavorite = isFavoriteChanged;
        notifyListeners();
      }  
    } catch (e) {
      print(e);
    }      
  }

  Icon meFavorite() {
    if (isFavorite == true) {
      return Icon(Icons.favorite);
    } else {
      return Icon(Icons.favorite_border);
    }   
  }

}