import 'package:flutter/material.dart';

class ExempleScreen2 extends StatefulWidget {
  const ExempleScreen2({super.key});

  @override
  State<ExempleScreen2> createState() => _ExempleScreen2State();
}

class _ExempleScreen2State extends State<ExempleScreen2> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.green, child: Center(child: Text('Exemple Screen 2')));
  }
}
