import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/badge_custom.dart';
import 'package:shop/pages/product_grid.dart';
import 'package:shop/utils/app_routes.dart';

import '../models/cart.dart';
import '../models/produto_list.dart';

enum FilterOptions {
  Favorite, 
  All,
}

class ProductsOverviewPage extends StatefulWidget {  

  ProductsOverviewPage({super.key});  

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {

  bool _showFavoriteOnly = false;

  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProductList>(context, listen: false).loadProducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(        
        title: Text('Minha Loja'), 
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions value) => {
              setState(() {
                if (value == FilterOptions.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              })              
            },
            itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Somente Favoritos'),   
                  value: FilterOptions.Favorite         
                ), 
                PopupMenuItem(
                  child: Text('Todos'),   
                  value: FilterOptions.All       
                )
              ]
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              }, 
              icon: Icon(Icons.shopping_cart)
            ),
            builder: (ctx, cart, child) => BadgeCustom(
              value: cart.itemsCount.toString(),
              child: child!
            ),
          ) 
        ],
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : ProductGrid(_showFavoriteOnly),
      drawer: AppDrawer(),
    );
  }
}

