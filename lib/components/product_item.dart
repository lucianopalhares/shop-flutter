import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/app_routes.dart';

import '../models/product.dart';
import '../models/produto_list.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  
  const ProductItem(
    {
      Key? key, 
      required this.product
    }
  ) : super(key: key);

  Future<void> confirmDeleteProduct(Product product, BuildContext context) {

    final msgBottom = ScaffoldMessenger.of(context);
    
    return showDialog(
      context: context, 
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Por favor confirme.'),
          content: const Text('Quer mesmo excluir o produto?'),actions: [
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(true)
              }, 
              child: const Text('Sim')
            ), 
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(false)
              }, 
              child: const Text('Não')
            )
          ],
        );
      }
    ).then((value) async {
      if (value ?? false) {
        try {
          await Provider.of<ProductList>(context, listen: false).deleteProduct(product);
        } catch (e) {
          msgBottom.showSnackBar(
            SnackBar(content: Text(e.toString()))
          );          
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product
                );
              }, 
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor
            ),
            IconButton(
              onPressed: () {
                confirmDeleteProduct(product, context);
              }, 
              icon: Icon(Icons.delete), 
              color: Theme.of(context).errorColor
            ),
          ],
        ),
      ),
    );
  }
}