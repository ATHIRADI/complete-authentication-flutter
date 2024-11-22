import 'package:complete_auth/utils/colors.dart';
import 'package:complete_auth/utils/sizes.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatefulWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool isLoading = false;

  Future<void> handleTap() async {
    if (isLoading) return;

    setState(() => isLoading = true);
    try {
      widget.onTap();
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingSm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Material(
          color: isLoading ? AppColors.BlackColor : AppColors.Primary,
          child: InkWell(
            onTap: isLoading ? null : handleTap, // Disable tap if loading.
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    widget.icon,
                    height: 35,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.label.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.WhiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
