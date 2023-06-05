import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {

  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {

    final Product product = ModalRoute.of(context)?.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name)
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300, 
            pinned: true, 
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.name),
            ),
          ), 
          SliverList(
            delegate: SliverChildListDelegate(
             [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Hero(
                    tag: product.id,//um identificador unico
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'R\$ ${product.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10
                  ),
                  width: double.infinity,
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}

