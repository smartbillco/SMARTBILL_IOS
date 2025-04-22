import 'package:flutter/material.dart';

class TimeDivider extends StatelessWidget {
  final String title;
  const TimeDivider({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
            endIndent: 10,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
            indent: 10,
          ),
        ),
      ]
    );
  }
}