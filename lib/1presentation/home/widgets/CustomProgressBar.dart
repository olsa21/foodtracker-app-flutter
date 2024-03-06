import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double value;

  const CustomProgressBar({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: value,
          color: (value < 1) ? Colors.cyan : Colors.deepOrange,
          minHeight: 20,
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }
}
