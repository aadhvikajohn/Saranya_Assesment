import 'package:flutter/material.dart';

class MySocialButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool loading;
  final AssetImage image;

  MySocialButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.loading = false,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 330,
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(100)),
        child: TextButton(
          onPressed: onPressed,
          child: loading
              ? CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: image,
                      width: 30,
                    ),
                    // Icon(icon, color: const Color.fromARGB(255, 38, 4, 99)),
                    SizedBox(width: 10),
                    Text(
                      title,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
