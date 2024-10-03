import 'package:flutter/material.dart';

class Marketplace extends StatelessWidget {
  const Marketplace({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("marketplace"),
        ),
      ),
    );
  }
}
