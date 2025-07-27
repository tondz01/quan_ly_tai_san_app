import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/note/widget/note_view.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi chú và hoạt động'),
        backgroundColor: const Color(0xFF703070),
        foregroundColor: Colors.white,
      ),
      body: const NoteView(),
    );
  }
} 