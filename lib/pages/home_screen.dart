import 'package:complete_auth/components/page_heading.dart';
import 'package:complete_auth/components/custom_button.dart';
import 'package:complete_auth/components/custom_text_button.dart';
import 'package:complete_auth/pages/login_screen.dart';
import 'package:complete_auth/services/auth_methods.dart';
import 'package:complete_auth/utils/sizes.dart';
import 'package:complete_auth/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userData = await AuthMethod().getUserData(currentUser.uid);
        if (mounted) {
          setState(() {
            name = userData['name'] ?? 'Unknown User';
          });
        }
      }
    } catch (e) {
      AppHelpers.showSnackBar(context, 'Error fetching user data');
    }
  }

  Future<void> _logOut() async {
    setState(() => isLoading = true);

    final shouldLogOut = await _showLogOutConfirmation();
    if (shouldLogOut == true) {
      await AuthMethod().signOut(context: context);
      if (mounted) {
        AppHelpers.navigateReplace(context, const LoginScreen());
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteAccount() async {}

  Future<bool?> _showLogOutConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Are you sure you want to log out?"),
        actions: [
          CustomTextButton(
            textString: "Cancel".toUpperCase(),
            onPressed: () => Navigator.pop(context, false),
          ),
          CustomTextButton(
            textString: "Log out".toUpperCase(),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeading(text: "Welcome \nHome"),
                  const SizedBox(height: AppSizes.itemSpace),
                  Text(
                    "Hello, $name",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  // const SizedBox(height: AppSizes.itemSpace),
                  Spacer(),
                  CustomButton(
                    isLoading: isLoading,
                    text: "LOG OUT",
                    onTap: isLoading ? null : _logOut,
                  ),

                  const SizedBox(height: AppSizes.itemSpace),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
