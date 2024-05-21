import 'package:flutter/material.dart';

class HomeTextField extends StatelessWidget {
  final TextEditingController controller;
  const HomeTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: null,
      maxLines: null,
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Type your message...',
        border: InputBorder.none,
      ),
    );
  }
}
