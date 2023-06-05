import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/app_routes.dart';

import '../models/auth.dart';
import '../models/cart.dart';
import '../models/product.dart';

class ProductGridItem extends StatelessWidget {
 
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

    final auth = Provider.of<Auth>(
      context, 
      listen: false
    ); 

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector( 
            child: Hero(
              tag: product.id,//um identificador unico
              child: FadeInImage(
                placeholder: AssetImage('assets/images/product-placeholder.png'), 
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover
              ),
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
                  product.toggleFavorite(
                    context, 
                    auth.token ?? '', 
                    auth.userId ?? ''
                  );
                }, 
                icon: Icon(productConsumer.isFavorite ? Icons.favorite : Icons.favorite_outline), 
                color: Theme.of(context).colorScheme.secondary,                 
              ),
            ),
            title: Text(product.name, textAlign: TextAlign.center,), 
            trailing: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Produto adicionado com sucesso'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'DESFAZER', 
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }
                    )
                  )
                );
                cart.addItem(product);
              }, 
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).colorScheme.secondary
            ),
          )
        ),
    );
  }
}
