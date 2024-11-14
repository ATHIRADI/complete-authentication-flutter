import 'package:complete_auth/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextInputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final String? labelText;
  final String? errorText;
  final IconData? icon;
  final TextInputType textInputType;
  final double? customVerticalPadding;

  const CustomTextInputField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.labelText,
    this.errorText,
    required this.textInputType,
    this.icon,
    this.isPass = false,
    this.customVerticalPadding = 10.0,
  });

  @override
  State<CustomTextInputField> createState() => _CustomTextInputFieldState();
}

class _CustomTextInputFieldState extends State<CustomTextInputField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.isPass;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.customVerticalPadding!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText ?? '',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: widget.textEditingController,
            decoration: InputDecoration(
              prefixIcon: widget.icon == null
                  ? null
                  : Icon(
                      widget.icon,
                      color: AppColors.lightPrimary,
                    ),
              suffixIcon: widget.isPass == false
                  ? null
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.lightPrimary,
                      ),
                    ),
              hintText: widget.hintText,
              errorText: widget.errorText, // Apply error text here
            ),
            keyboardType: widget.textInputType,
            obscureText: _isPasswordVisible,
          ),
        ],
      ),
    );
  }
}
