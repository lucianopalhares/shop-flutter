import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  
  const OrderWidget({
    Key? key,
    required this.order  
  });

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final itemsHeightInteger = (widget.order.products.length * 25) + 10;

    final itemsHeight = itemsHeightInteger.toDouble();

    return AnimatedContainer(
      duration: Duration(milliseconds: 300), 
      height: _expanded ? itemsHeight + 80 : 80,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }, 
                icon: Icon(Icons.expand_more)
              ),
            ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300), 
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4
                ),
                height: _expanded ? itemsHeight : 0,
                child: ListView(
                  children: widget.order.products.map(
                    (product) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            '${product.quantity}x R\$ ${product.price}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey
                            ),
                          )
                        ],
                      );
                    },
                  ).toList(),
                )
              )
          ],
        ),
      ),
    );
  }
}