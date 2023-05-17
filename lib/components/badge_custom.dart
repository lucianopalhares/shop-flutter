


import 'package:flutter/material.dart';

class BadgeCustom extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  const BadgeCustom({
    Key? key, 
    required this.child,
    required this.value, 
    this.color
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), 
              color: color ?? Colors.red
            ),
            constraints: BoxConstraints(
              maxHeight: 16, 
              minHeight: 16 
            ),
            child: Text(value, style: TextStyle(fontSize: 10), textAlign: TextAlign.center,)
          )
        )
      ],
    );
  }}