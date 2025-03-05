import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final Color color;
  final Color textColor;
  final double width; // Added width property
  final double textSize;
  final double borderRadius;
  final double height;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.color = Colors.purple,
    this.textColor = Colors.white,
    this.width = double.infinity, // Default to full width like input field
    this.textSize = 16,
    this.borderRadius = 25,
    this.height = 50

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // Match input field width
      height: height, // Match input field height
      child: isOutlined
          ? OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius), // Match input field shape
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: textSize
          ),
        ),
      )
          : ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius), // Match input field shape
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: textSize,
          ),
        ),
      ),
    );
  }
}