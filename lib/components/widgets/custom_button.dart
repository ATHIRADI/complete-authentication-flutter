import 'package:complete_auth/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double? customVerticalPadding;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.customVerticalPadding = 15.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: customVerticalPadding!),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Material(
          color: isLoading == true
              ? AppColors.lightBlackColor
              : AppColors.lightPrimary,
          child: InkWell(
            onTap: isLoading ? null : onTap,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              child: Text(
                text.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.lightWhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
