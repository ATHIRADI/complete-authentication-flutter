import 'package:complete_auth/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AppHelpers {
  AppHelpers._();

  // SnackBar Utility
  static void showSnackBar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.lightWhiteColor,
                ) ??
            const TextStyle(color: AppColors.lightWhiteColor),
      ),
      duration: duration,
    );
    if (ScaffoldMessenger.maybeOf(context) != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print("SnackBar context is not mounted yet.");
    }
  }

  // showDialog
  static void showCustomDialog({
    required BuildContext context,
    required List<Widget> Function(StateSetter setState) childrenBuilder,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    childrenBuilder(setState), // Pass the setState to children
              ),
            );
          },
        );
      },
    );
  }

  // Email Validation
  static bool isValidEmail(String email) => RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(email);

  // Password Validation
  static bool isValidPassword(String password) {
    final strongPasswordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );

    return strongPasswordRegex.hasMatch(password);
  }

  // Navigation Utilities
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

  // Hide Keyboard
  static void hideKeyboard(BuildContext context) =>
      FocusScope.of(context).unfocus();
}
