import 'package:complete_auth/utils/colors.dart';
import 'package:flutter/material.dart';

class AppHelpers {
  AppHelpers._();

  static void showSnackBar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.WhiteColor,
                ) ??
            const TextStyle(color: AppColors.WhiteColor),
      ),
      duration: duration,
    );
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackBar);
  }

  static void showCustomDialog({
    required BuildContext context,
    required List<Widget> Function(StateSetter setState) childrenBuilder,
  }) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: childrenBuilder(setState),
          ),
        ),
      ),
    );
  }

  static bool isValidEmail(String email) => RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(email);

  static bool isValidPassword(String password) {
    return RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    ).hasMatch(password);
  }

  static Future<void> navigateTo(BuildContext context, Widget page) =>
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );

  static Future<void> navigateReplace(BuildContext context, Widget page) =>
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page),
      );

  static void navigateBack(BuildContext context) => Navigator.pop(context);

  static void hideKeyboard(BuildContext context) =>
      FocusScope.of(context).unfocus();
}
