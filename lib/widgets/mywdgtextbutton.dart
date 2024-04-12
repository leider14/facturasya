import 'package:flutter/material.dart';

class MyWdgTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  const MyWdgTextButton({super.key, required this.text, required this.onPressed});

  @override
  State<MyWdgTextButton> createState() => _MyWdgTextButtonState();
}

class _MyWdgTextButtonState extends State<MyWdgTextButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        widget.text,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}