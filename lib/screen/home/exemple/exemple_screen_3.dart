import 'package:flutter/material.dart';

class ExempleScreen3 extends StatefulWidget {
  const ExempleScreen3({super.key});

  @override
  State<ExempleScreen3> createState() => _ExempleScreen3State();
}

class _ExempleScreen3State extends State<ExempleScreen3> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.blue, child: Center(child: Text('Exemple Screen 3')));
  }
}
