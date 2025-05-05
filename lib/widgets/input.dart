import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String? placeholder;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomInputField({
    super.key,
    required this.label,
    this.placeholder,
    required this.controller,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: const TextStyle(
              color: Colors.black45, // Faded style
              fontWeight: FontWeight.bold,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _toggleVisibility,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
