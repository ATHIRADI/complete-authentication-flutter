import 'package:complete_auth/components/page_heading.dart';
import 'package:complete_auth/components/custom_button.dart';
import 'package:complete_auth/components/custom_text_input_field.dart';
import 'package:complete_auth/pages/login_screen.dart';
import 'package:complete_auth/utils/colors.dart';
import 'package:complete_auth/utils/sizes.dart';
import 'package:complete_auth/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? emailError;
  bool isLoading = false; // Tracks the loading state.

  /// Validates the email and sends a password reset email if valid.
  Future<void> _validateAndSubmit(StateSetter setState) async {
    AppHelpers.hideKeyboard(context);

    final email = emailController.text.trim();
    final isValid = AppHelpers.isValidEmail(email);

    setState(() =>
        emailError = isValid ? null : "Please enter a valid email address");

    if (isValid) {
      setState(() => isLoading = true); // Start loading.
      try {
        await _auth.sendPasswordResetEmail(email: email);
        setState(() => emailError = null); // Clear error if any.
        AppHelpers.showSnackBar(context, "Reset link sent to your email.");
        emailController.clear();
        Future.delayed(const Duration(seconds: 2), () {
          AppHelpers.navigateReplace(context, const LoginScreen());
        });
      } catch (error) {
        AppHelpers.showSnackBar(context, "Error: ${error.toString()}");
      } finally {
        setState(() => isLoading = false); // Stop loading.
      }
    }
  }

  /// Displays the custom dialog for resetting the password.
  void _showForgotPasswordDialog() {
    AppHelpers.showCustomDialog(
      context: context,
      childrenBuilder: (StateSetter setState) => [
        const PageHeading(text: "Forgot Your \nPassword?"),
        const SizedBox(height: AppSizes.itemSpace),
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
          onTap: isLoading
              ? null // Disable button while loading.
              : () => _validateAndSubmit(setState),
          isLoading: isLoading, // Pass loading state to the button.
          text: "Send",
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: _showForgotPasswordDialog,
        child: Text(
          "Forgot Password?".toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.Primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
