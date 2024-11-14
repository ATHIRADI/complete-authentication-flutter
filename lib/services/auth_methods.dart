import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_auth/utils/helpers/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signupUser({
    required context,
    required String name,
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        if (!AppHelpers.isValidEmail(email)) {
          AppHelpers.showSnackBar(
              context, "Please enter a valid email address.");
          return "Invalid email";
        }
        if (!AppHelpers.isValidPassword(password)) {
          AppHelpers.showSnackBar(
            context,
            "Password must be at least 8 characters long and include an uppercase letter, a lowercase letter, a number, and a special character.",
          );
          return "Weak password";
        }

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
        });

        AppHelpers.showSnackBar(context, "Account created successfully!");
        res = "success";
      } else {
        AppHelpers.showSnackBar(context, "Please fill out all fields.");
      }
    } on FirebaseAuthException catch (e) {
      res = _handleAuthErrors(context, e);
    } catch (err) {
      res = "An error occurred: $err";
      // AppHelpers.showSnackBar(context, res);
    }
    return res;
  }

  Future<String> loginUser({
    required context,
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        if (!AppHelpers.isValidEmail(email)) {
          AppHelpers.showSnackBar(
            context,
            "Please enter a valid email address.",
          );
          return "Invalid email";
        }

        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        AppHelpers.showSnackBar(context, "Logged in successfully!");
        res = "success";
      } else {
        AppHelpers.showSnackBar(context, "Please enter all fields.");
      }
    } on FirebaseAuthException catch (e) {
      res = _handleAuthErrors(context, e);
    } catch (err) {
      res = "An error occurred: $err";
      // AppHelpers.showSnackBar(context, res);
    }
    return res;
  }

  Future<void> signOut({required context}) async {
    try {
      await _auth.signOut();
      AppHelpers.showSnackBar(context, "Signed out successfully!");
    } catch (err) {
      AppHelpers.showSnackBar(context, "Error signing out: ${err.toString()}");
    }
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection("users").doc(uid).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }
}

String _handleAuthErrors(context, FirebaseAuthException e) {
  String message;
  switch (e.code) {
    case 'user-not-found':
      message = "No user found with that email.";
      break;
    case 'invalid-credential':
      message = "The credential is incorrect, malformed, or expired.";
      break;
    case 'wrong-password':
      message = "Incorrect password. Please try again.";
      break;
    case 'email-already-in-use':
      message = "The email is already in use by another account.";
      break;
    case 'invalid-email':
      message = "The email address is badly formatted.";
      break;
    case 'user-disabled':
      message = "This account has been disabled. Please contact support.";
      break;
    case 'too-many-requests':
      message = "Too many login attempts. Try again later.";
      break;
    default:
      message = e.message ?? "Login failed.";
  }
  AppHelpers.showSnackBar(context, message);
  return message;
}
