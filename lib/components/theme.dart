import 'package:flutter/material.dart';

BoxDecoration boxDecorationBlu() {
  return const BoxDecoration(
    color: Color.fromARGB(255, 3, 107, 185),
    boxShadow: [
      BoxShadow(
        color: Color.fromARGB(63, 0, 0, 0),
        offset: Offset(0.0, 4.0),
        blurRadius: 23.0,
      )
    ],
    gradient: LinearGradient(
      begin: Alignment(0.0, -1.0),
      end: Alignment(0.0, 0.9999999999999998),
      stops: [0.0, 1.0],
      colors: [
        Color.fromARGB(255, 3, 107, 185),
        Color.fromARGB(255, 9, 25, 99),
      ],
    ),
  );
}

BoxDecoration boxDecorationBianco() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(35),
    boxShadow: const [
      BoxShadow(
        color: Color.fromARGB(63, 0, 0, 0),
        offset: Offset(0.0, 4.0),
        blurRadius: 50.0,
      )
    ],
  );
}
