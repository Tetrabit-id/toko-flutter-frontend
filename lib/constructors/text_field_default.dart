import 'package:flutter/material.dart';
import '../style/styles.dart';

class TextFieldDefault extends StatefulWidget {
  const TextFieldDefault(
      {Key? key,
      this.obscureText = false,
      required this.label,
      required this.controller,
      required this.size,
      required this.onChanged})
      : super(key: key);
  final bool obscureText;
  final String label;
  final TextEditingController controller;
  final Size size;
  final Function(String) onChanged;
  @override
  State<TextFieldDefault> createState() => _TextFieldDefaultState();
}

class _TextFieldDefaultState extends State<TextFieldDefault> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.size.width / 7.6),
        child: TextField(
            onChanged: widget.onChanged,
            obscureText: widget.obscureText,
            cursorHeight: 18,
            controller: widget.controller,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: widget.size.width / 20),
              filled: true,
              enabled: true,
              border: const OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: const TextStyle(color: Colors.black),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor)),
              hintText: widget.label,
            )));
  }
}

Padding textFieldDefault(String label, Size size,
    TextEditingController controller, bool obscureText) {
  return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 7.6),
      child: TextField(
          obscureText: obscureText,
          cursorHeight: 18,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: size.width / 20),
            filled: true,
            enabled: true,
            border: const OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: const TextStyle(color: Colors.black),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor)),
            hintText: label,
          )));
}

Padding textFieldDefaultIcon(String label, Size size, bool obscureText,
    Widget icon, void Function(String)? onChanged) {
  return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 7.6),
      child: TextField(
          obscureText: obscureText,
          onChanged: onChanged,
          cursorHeight: 18,
          decoration: InputDecoration(
            prefixIcon: icon,
            contentPadding: EdgeInsets.symmetric(horizontal: size.width / 20),
            filled: true,
            enabled: true,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: const TextStyle(color: Colors.black),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            hintText: label,
          )));
}

Padding textFieldDefaultIconC(
  String label,
  Size size,
  bool obscureText,
  Widget icon,
  TextEditingController controller,
  //  void Function(String)? onChanged
) {
  return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 7.6),
      child: TextField(
          obscureText: obscureText,
          controller: controller,
          // onChanged: onChanged,
          cursorHeight: 18,
          decoration: InputDecoration(
            prefixIcon: icon,
            contentPadding: EdgeInsets.symmetric(horizontal: size.width / 20),
            filled: true,
            enabled: true,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: const TextStyle(color: Colors.black),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            hintText: label,
          )));
}
