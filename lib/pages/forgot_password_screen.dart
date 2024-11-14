import 'package:complete_auth/components/page_heading.dart';
import 'package:complete_auth/components/widgets/custom_button.dart';
import 'package:complete_auth/components/widgets/custom_text_input_field.dart';
import 'package:complete_auth/pages/login_screen.dart';
import 'package:complete_auth/utils/constants/colors.dart';
import 'package:complete_auth/utils/constants/sizes.dart';
import 'package:complete_auth/utils/helpers/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  String? emailError;

  void validateAndSubmit(StateSetter setState) async {
    setState(() {
      emailError = AppHelpers.isValidEmail(emailController.text)
          ? null
          : "Please enter a valid email address";
    });

    if (emailError == null) {
      try {
        await auth.sendPasswordResetEmail(email: emailController.text);
        AppHelpers.showSnackBar(context, "Reset link sent to your email.");
        AppHelpers.navigateReplace(context, const LoginScreen());
        emailController.clear();
      } catch (error) {
        AppHelpers.showSnackBar(context, "Error: ${error.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          AppHelpers.showCustomDialog(
            context: context,
            childrenBuilder: (StateSetter setState) => [
              const PageHeading(text: "Forgot Your \nPassword?"),
              const SizedBox(
                height: AppSizes.itemSpace,
              ),
              Text(
                "Enter your email address and we will share a link to create a new password.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              CustomTextInputField(
                textEditingController: emailController,
                icon: Icons.email,
                hintText: 'Enter your email address',
                textInputType: TextInputType.emailAddress,
                customVerticalPadding: 0,
                errorText: emailError,
              ),
              CustomButton(
                onTap: () => validateAndSubmit(setState),
                text: "Send",
              ),
            ],
          );
        },
        child: Text(
          "Forgot Password?".toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppColors.lightPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
