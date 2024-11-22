import 'package:complete_auth/components/custom_nav_text%20.dart';
import 'package:complete_auth/components/page_heading.dart';
import 'package:complete_auth/components/socials.dart';
import 'package:complete_auth/components/custom_button.dart';
import 'package:complete_auth/components/custom_text_input_field.dart';
import 'package:complete_auth/pages/home_screen.dart';
import 'package:complete_auth/pages/login_screen.dart';
import 'package:complete_auth/services/auth_methods.dart';
import 'package:complete_auth/utils/sizes.dart';
import 'package:complete_auth/utils/helpers.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  final Map<String, String?> errorMessages = {
    'name': null,
    'email': null,
    'password': null,
  };

  void signupUser() async {
    if (isLoading) return;

    AppHelpers.hideKeyboard(context);
    if (!validateInputs()) return;

    setLoadingState(true);
    try {
      String res = await AuthMethod().signupUser(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        context: context,
      );

      if (res == "success") {
        AppHelpers.navigateReplace(context, const HomeScreen());
      } else {
        AppHelpers.showSnackBar(context, res);
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
      errorMessages['name'] =
          nameController.text.isEmpty ? "Name is required" : null;
      errorMessages['email'] = emailController.text.isEmpty ||
              !AppHelpers.isValidEmail(emailController.text)
          ? "Enter a valid email address"
          : null;
      errorMessages['password'] = !AppHelpers.isValidPassword(
              passwordController.text)
          ? "Password must be at least 8 characters long and include uppercase, lowercase, number, and special character."
          : null;
    });

    return errorMessages.values.every((error) => error == null);
  }

  void setLoadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                    text: "Create \nAn Account",
                  ),
                  Column(
                    children: [
                      CustomTextInputField(
                        textEditingController: nameController,
                        hintText: 'Enter your name',
                        labelText: "Name",
                        icon: Icons.person,
                        textInputType: TextInputType.text,
                        errorText: errorMessages['name'], // Set error text
                      ),
                      CustomTextInputField(
                        icon: Icons.email,
                        textEditingController: emailController,
                        labelText: "Email Address",
                        hintText: 'Enter your email',
                        textInputType: TextInputType.text,
                        errorText: errorMessages['email'], // Set error text
                      ),
                      CustomTextInputField(
                        icon: Icons.lock,
                        textEditingController: passwordController,
                        labelText: "Password",
                        hintText: 'Enter your password',
                        textInputType: TextInputType.text,
                        isPass: true,
                        errorText: errorMessages['password'], // Set error text
                      ),
                      const SizedBox(
                        height: AppSizes.itemSpace,
                      ),
                      CustomButton(
                        onTap: isLoading ? null : signupUser,
                        text: "Sign Up",
                        isLoading: isLoading,
                      ),
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
                            "Have an account already?",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const CustomNavText(
                            text: "Log In",
                            destination: LoginScreen(),
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
