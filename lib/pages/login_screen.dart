import 'package:complete_auth/components/custom_nav_text .dart';
import 'package:complete_auth/components/page_heading.dart';
import 'package:complete_auth/components/socials.dart';
import 'package:complete_auth/components/custom_button.dart';
import 'package:complete_auth/components/custom_text_input_field.dart';
import 'package:complete_auth/pages/forgot_password_screen.dart';
import 'package:complete_auth/pages/home_screen.dart';
import 'package:complete_auth/pages/register_screen.dart';
import 'package:complete_auth/services/auth_methods.dart';
import 'package:complete_auth/utils/sizes.dart';
import 'package:complete_auth/utils/helpers.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? emailError;
  String? passwordError;
  bool isLoading = false;

  void loginUser() async {
    if (isLoading) return;

    AppHelpers.hideKeyboard(context);
    if (!validateInputs()) return;

    setLoadingState(true);
    try {
      String res = await AuthMethod().loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        context: context,
      );

      if (res == "success") {
        AppHelpers.navigateReplace(context, const HomeScreen());
      } else {
        AppHelpers.showSnackBar(context, res); // Show specific error
      }
    } catch (e) {
      AppHelpers.showSnackBar(context, "An error occurred. Please try again.");
    } finally {
      Future.delayed(const Duration(seconds: 3), () {
        setLoadingState(false);
      });
    }
  }

  bool validateInputs() {
    setState(() {
      emailError = emailController.text.isEmpty ||
              !AppHelpers.isValidEmail(emailController.text)
          ? "Enter a valid email address"
          : null;
      passwordError =
          passwordController.text.isEmpty ? "Enter your password" : null;
    });
    return emailError == null && passwordError == null;
  }

  void setLoadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: height,
            child: Padding(
              padding: AppSizes.paddingScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeading(
                    text: "Welcome \nBack",
                  ),
                  Column(
                    children: [
                      CustomTextInputField(
                        icon: Icons.email,
                        textEditingController: emailController,
                        hintText: 'Enter your email',
                        labelText: "Email Address",
                        textInputType: TextInputType.emailAddress,
                        errorText: emailError, // Show email error
                      ),
                      CustomTextInputField(
                        icon: Icons.lock,
                        textEditingController: passwordController,
                        labelText: "Password",
                        hintText: 'Enter your password',
                        textInputType: TextInputType.text,
                        errorText: passwordError, // Show password error
                        isPass: true,
                      ),
                      const SizedBox(
                        height: AppSizes.itemSpace,
                      ),
                      CustomButton(
                        onTap: isLoading ? null : loginUser,
                        text: "Log In",
                        isLoading: isLoading,
                      ),
                      const ForgotPasswordScreen(),
                    ],
                  ),
                  Column(
                    children: [
                      const Socials(),
                      const SizedBox(
                        height: AppSizes.itemSpace,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const CustomNavText(
                            text: "Sign Up",
                            destination: RegisterScreen(),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: AppSizes.sectionSpace,
                      ),
                    ],
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
