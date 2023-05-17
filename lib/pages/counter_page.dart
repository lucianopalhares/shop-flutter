
import 'package:flutter/material.dart';

import '../providers/counter.dart';


class CounterPage extends StatelessWidget {

  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(CounterProvider.of(context)?.state.value.toString() ?? '0')
      ),
      body: Column(children: [
        Text('0'), 
        IconButton(onPressed: () {
          CounterProvider.of(context)?.state.inc();
          print(CounterProvider.of(context)?.state.value);
        }, icon: Icon(Icons.add)),
        IconButton(onPressed: () {
          CounterProvider.of(context)?.state.dec();
          print(CounterProvider.of(context)?.state.value);
        }, icon: Icon(Icons.delete))
      ]),
    );
  }
}

