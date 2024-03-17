import 'package:flutter/material.dart';

class MyButoon extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool loading;
  MyButoon(
      {super.key,
      required this.title,
      required this.onPressed,
      this.loading = false});

  Widget build(BuildContext context) {
    return Container(
      width: 335,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 36, 9, 83),
          borderRadius: BorderRadius.circular(10)),
      child: TextButton(
          onPressed: onPressed,
          child: loading
              ? CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
    );
  }
}
