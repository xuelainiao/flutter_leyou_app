import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final int maxLines;
  final double maxHeight;
  final double minHeight;
  final Color backgroundColor;
  final double borderRadius;
  final TextEditingController? controller;
  final Function? onSubmit;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.maxLines = 1,
    this.maxHeight = 200,
    this.minHeight = 40,
    this.backgroundColor = Colors.white,
    this.borderRadius = 0.0,
    this.controller,
    this.onChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        minHeight: minHeight,
      ),
      child: TextField(
        maxLines: null,
        controller: controller,
        textInputAction: TextInputAction.send,
        decoration: const InputDecoration(
          filled: true,
          counterText: '',
          fillColor: Colors.transparent,
          border: InputBorder.none,
        ),
        // onSubmitted: (value) {
        //   onSubmit?.call(value);
        // },
        onEditingComplete: () {
          onSubmit?.call();
        },
        onChanged: (value) {
          onChanged?.call(value);
        },
      ),
    );
  }
}
