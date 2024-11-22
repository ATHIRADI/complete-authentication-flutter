import 'package:complete_auth/utils/colors.dart';
import 'package:complete_auth/utils/helpers.dart';
import 'package:flutter/material.dart';

class CustomNavText extends StatelessWidget {
  final String text;
  final Widget destination;
  const CustomNavText({
    super.key,
    required this.text,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHelpers.navigateTo(context, destination);
      },
      child: Text(
        " $text".toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AppColors.Primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
