import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final String text;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(22),
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          splashColor: Colors.white.withOpacity(0.3),
          onTap: onTap,
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.9,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
