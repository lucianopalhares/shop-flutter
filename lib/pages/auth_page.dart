import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 188, 117, 0.9),
                ], 
                begin: Alignment.topLeft, 
                end: Alignment.bottomRight
              )
            )
          ), 
          Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  child: Text(
                    'Minha Loja',
                    style: TextStyle(
                      fontSize: 45, 
                      fontFamily: 'Anton', 
                      color: Theme.of(context).accentTextTheme.headline6?.color
                    ), 
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}