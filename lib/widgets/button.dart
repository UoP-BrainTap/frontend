import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final Color color;
  final Color textColor;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.color = Colors.purple,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return isOutlined
        ? OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    )
        : ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    );
  }
}