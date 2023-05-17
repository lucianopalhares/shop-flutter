import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/product_item.dart';
import '../models/product.dart';
import '../models/produto_list.dart';

class ProductGrid extends StatelessWidget {

  final bool showFavoriteOnly;

  ProductGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts = showFavoriteOnly ? provider.favoriteItems : provider.items;

    print(provider.items);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2, 
        crossAxisSpacing: 10, 
        mainAxisSpacing: 10
      ), 
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i], 
        child: ProductItem(),
      ), 
      itemCount: loadedProducts.length,
      padding: EdgeInsets.all(10),
    );
  }
}