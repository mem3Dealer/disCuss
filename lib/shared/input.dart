import 'package:flutter/material.dart';

InputDecoration textInputDecoration = InputDecoration(
    // hintText: 'Email',
    // fillColor: Colors.transparent,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.purple.shade900, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.purple.shade800, width: 2),
    ));
