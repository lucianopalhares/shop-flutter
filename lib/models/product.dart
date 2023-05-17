import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id, 
    required this.title,
    required this.description, 
    required this.price, 
    required this.imageUrl, 
    this.isFavorite = false,
  });

  get isFavorited => isFavorite;

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();    
  }

  Icon meFavorite() {
    if (isFavorite == true) {
      return Icon(Icons.favorite);
    } else {
      return Icon(Icons.favorite_border);
    }   
  }

}