import 'package:complete_auth/utils/colors.dart';
import 'package:complete_auth/utils/sizes.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final double customVerticalPadding;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.customVerticalPadding = AppSizes.paddingMd,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: customVerticalPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Material(
          color: isLoading
              ? AppColors.BlackColor.withOpacity(0.6)
              : AppColors.Primary,
          child: InkWell(
            onTap: isLoading ? null : onTap,
            child: Container(
              alignment: Alignment.center,
              padding: AppSizes.buttonpadding,
              child: Text(
                isLoading ? "Loading..." : text.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.WhiteColor,
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
