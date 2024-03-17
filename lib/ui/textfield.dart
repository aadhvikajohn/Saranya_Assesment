// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hinttext;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  TextEditingController controller = TextEditingController();
  MyTextField({super.key, required this.hinttext, required this.controller,   this.prefixIcon,this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: const Color(0xffffffff))),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: .5, color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),

          labelText: hinttext,
          prefixIcon: prefixIcon ?? const SizedBox(),
          suffixIcon: suffixIcon ?? const SizedBox(),
        ),
      ),
    );
  }
}
