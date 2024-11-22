import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String textString;
  final VoidCallback onPressed;

  const CustomTextButton({
    super.key,
    required this.textString,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        textString,
      ),
    );
  }
}
