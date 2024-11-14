import 'package:complete_auth/components/custom_nav_text%20.dart';
import 'package:complete_auth/components/page_heading.dart';
import 'package:complete_auth/components/widgets/custom_button.dart';
import 'package:complete_auth/components/widgets/custom_text_input_field.dart';
import 'package:complete_auth/pages/home_screen.dart';
import 'package:complete_auth/pages/login_screen.dart';
import 'package:complete_auth/services/auth_methods.dart';
import 'package:complete_auth/utils/constants/sizes.dart';
import 'package:complete_auth/utils/helpers/helpers.dart';
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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signupUser() async {
    AppHelpers.hideKeyboard(context);

    setState(() {
      errorMessages['name'] =
          nameController.text.isEmpty ? "Name is required" : null;
      errorMessages['email'] = emailController.text.isEmpty
          ? "Enter a valid email address"
          : !AppHelpers.isValidEmail(emailController.text)
              ? "Invalid email format"
              : null;
      errorMessages['password'] = !AppHelpers.isValidPassword(
              passwordController.text)
          ? "Password must be at least 8 characters long and include uppercase, lowercase, number, and special character."
          : null;
    });

    if (errorMessages.values.any((error) => error != null)) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    String res = await AuthMethod().signupUser(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
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
                text: "Create \nAn Account",
              ),
              const Spacer(),
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
              CustomButton(
                onTap: signupUser,
                text: isLoading ? "Loading..." : "Sign Up",
                isLoading: isLoading,
              ),
              // const SizedBox(
              //   height: AppSizes.itemSpace,
              // ),
              const Spacer(),
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
        ),
      ),
    );
  }
}
