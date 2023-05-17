import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/app_routes.dart';

import '../models/cart.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
 
 var test = false;

  @override
  Widget build(BuildContext context) {

    final product = Provider.of<Product>(
      context, 
      listen: false
    );  

    final cart = Provider.of<Cart>(
      context, 
      listen: false
    ); 

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector( 
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PRODUCT_DETAIL, 
                arguments: product
              );
            },
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, productConsumer, exemploPassarAlgoQueNuncaMuda) => IconButton(
                onPressed: () {
                  product.toggleFavorite();
                }, 
                icon: Icon(productConsumer.isFavorite ? Icons.favorite : Icons.favorite_outline), 
                color: Theme.of(context).colorScheme.secondary,                 
              ),
            ),
            title: Text(product.title, textAlign: TextAlign.center,), 
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product);
                print(cart.itemsCount);
              }, 
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).colorScheme.secondary
            ),
          )
        ),
    );
  }
}
