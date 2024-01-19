import 'package:flutter/material.dart';

class Decorations extends StatefulWidget {
  const Decorations({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DecorationState();
}

/// The state for DetailsScreen
class DecorationState extends State<Decorations> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decorations'),
      ),
      body: const Center(
        child: Text('Decorations'),
      ),
    );
  }
}