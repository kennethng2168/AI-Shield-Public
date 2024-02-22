import 'package:flutter/material.dart';

openIconSnackBar(context, String text, Widget icon) {
  // This should be called by an on pressed/tap function
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Row(
      children: [
        icon,
        SizedBox(
          width: 5,
        ),
        Text(text)
      ],
    ),
    duration: const Duration(milliseconds: 2500),
  ));
}

deleteIconSnackBar(context, String text, Widget icon) {
  // This should be called by an on pressed/tap function
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Row(
      children: [
        icon,
        SizedBox(
          width: 5,
        ),
        Text(text)
      ],
    ),
    duration: const Duration(milliseconds: 2500),
  ));
}
