import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Function()? onPressed;

  const MyFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: () {
      if (onPressed != null) {
        onPressed!();
      }
    }, child: Icon(Icons.add));
  }
}
