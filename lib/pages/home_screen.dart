import 'package:complete_auth/components/page_heading.dart';
import 'package:complete_auth/components/widgets/custom_button.dart';
import 'package:complete_auth/components/widgets/custom_text_button.dart';
import 'package:complete_auth/pages/login_screen.dart';
import 'package:complete_auth/services/auth_methods.dart';
import 'package:complete_auth/utils/constants/sizes.dart';
import 'package:complete_auth/utils/helpers/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name = '';
  bool isLoading = false;

  Future<void> fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        Map<String, dynamic> userData =
            await AuthMethod().getUserData(currentUser.uid);
        setState(() {
          name = userData['name'] ?? 'Unknown User';
          isLoading = false;
        });
      }
    } catch (e) {
      AppHelpers.showSnackBar(context, 'Error fetching user data');
    }
  }

  Future<void> _logOut(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final bool? shouldLogOut = await _showLogOutConfirmation();

    if (shouldLogOut == true) {
      await AuthMethod().signOut(context: context);

      if (mounted) {
        AppHelpers.navigateReplace(context, const LoginScreen());
      }
    }
  }

  Future<bool?> _showLogOutConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          "Are you sure you want to log out?",
        ),
        actions: [
          CustomTextButton(
            textString: "Cancel".toUpperCase(),
            onPressed: () {
              Navigator.pop(context, false);
              setState(() {
                isLoading = false;
              });
            },
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
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSizes.paddingScreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeading(
                text: "Welcome \nHome",
              ),
              const SizedBox(
                height: AppSizes.itemSpace,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      "Hello, $name",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
              const SizedBox(
                height: AppSizes.itemSpace,
              ),
              CustomButton(
                isLoading: isLoading,
                onTap: () {
                  _logOut(context);
                },
                text: "LOG OUT",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
