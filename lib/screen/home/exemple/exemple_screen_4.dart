import 'package:flutter/material.dart';

class ExempleScreen4 extends StatefulWidget {
  const ExempleScreen4({super.key});

  @override
  State<ExempleScreen4> createState() => _ExempleScreen4State();
}

class _ExempleScreen4State extends State<ExempleScreen4> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red, child: Center(child: Text('Exemple Screen 4')));
  }
}
