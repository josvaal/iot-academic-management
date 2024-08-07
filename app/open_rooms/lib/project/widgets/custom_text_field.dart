import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.size,
    this.type,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int? size;
  final TextInputType? type;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: type ?? TextInputType.text,
      maxLength: size ?? 20,
      controller: controller,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.blue.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
