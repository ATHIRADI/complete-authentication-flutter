import 'package:complete_auth/components/social_button.dart';
import 'package:complete_auth/pages/home_screen.dart';
import 'package:complete_auth/services/auth_methods.dart';
import 'package:complete_auth/utils/helpers.dart';
import 'package:flutter/material.dart';

class Socials extends StatelessWidget {
  const Socials({super.key});

  @override
  Widget build(BuildContext context) {
    void loginWithGoogle() async {
      final result = await AuthMethod().loginWithGoogle(context: context);

      if (result != null) {
        AppHelpers.navigateReplace(context, const HomeScreen());
      } else {
        AppHelpers.showSnackBar(context, "Google login failed.");
      }
    }

    void loginWithFb() async {
      final result = await AuthMethod().loginWithFacebook(context: context);

      if (result != null) {
        AppHelpers.navigateReplace(context, const HomeScreen());
      } else {
        AppHelpers.showSnackBar(context, "Facebook login failed.");
      }
    }

    final List<Map<String, dynamic>> buttons = [
      {
        "icon": "assets/img/fb.png",
        "label": "Facebook",
        "onTap": () => loginWithFb(),
      },
      {
        "icon": "assets/img/google.png",
        "label": "Google",
        "onTap": () => loginWithGoogle(),
      },
    ];

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons
          .map(
            (button) => SocialButton(
              icon: button['icon'],
              label: button['label'],
              onTap: button['onTap'],
            ),
          )
          .toList(),
    );
  }
}
