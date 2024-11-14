import 'package:complete_auth/components/custom_nav_text%20.dart';
import 'package:complete_auth/components/page_heading.dart';
import 'package:complete_auth/components/widgets/custom_button.dart';
import 'package:complete_auth/components/widgets/custom_text_input_field.dart';
import 'package:complete_auth/pages/forgot_password_screen.dart';
import 'package:complete_auth/pages/home_screen.dart';
import 'package:complete_auth/pages/register_screen.dart';
import 'package:complete_auth/services/auth_methods.dart';
import 'package:complete_auth/utils/constants/sizes.dart';
import 'package:complete_auth/utils/helpers/helpers.dart';
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

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    AppHelpers.hideKeyboard(context);

    setState(() {
      emailError = emailController.text.isEmpty ||
              !AppHelpers.isValidEmail(emailController.text)
          ? "Enter a valid email address"
          : null;
      passwordError =
          passwordController.text.isEmpty ? "Enter your password" : null;
    });

    if (emailError != null || passwordError != null) return;

    setState(() {
      isLoading = true;
    });

    String res = await AuthMethod().loginUser(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      context: context,
    );

    setState(() {
      isLoading = false;
    });

    if (res == "success") {
      AppHelpers.navigateReplace(context, const HomeScreen());
    } else {
      AppHelpers.showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSizes.paddingScreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeading(
                text: "Welcome \nBack",
              ),
              const Spacer(),
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
              CustomButton(
                onTap: loginUser,
                text: isLoading ? "Loading..." : "Log In",
                isLoading: isLoading,
              ),
              const ForgotPasswordScreen(),
              const Spacer(),
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
        ),
      ),
    );
  }
}
