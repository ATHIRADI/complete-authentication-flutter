import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_auth/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> _validateInputs({
    required context,
    required String email,
    required String password,
    String? name,
  }) async {
    if (email.isEmpty || password.isEmpty || (name != null && name.isEmpty)) {
      AppHelpers.showSnackBar(context, "Please fill out all fields.");
      return "Incomplete fields";
    }

    if (!AppHelpers.isValidEmail(email)) {
      AppHelpers.showSnackBar(context, "Please enter a valid email address.");
      return "Invalid email";
    }

    if (!AppHelpers.isValidPassword(password)) {
      AppHelpers.showSnackBar(
        context,
        "Password must be at least 8 characters long and include an uppercase letter, a lowercase letter, a number, and a special character.",
      );
      return "Weak password";
    }

    return "valid";
  }

  Future<String> signupUser({
    required context,
    required String name,
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      final validation = await _validateInputs(
        context: context,
        email: email,
        password: password,
        name: name,
      );
      if (validation != "valid") return validation;

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
    } on FirebaseAuthException catch (e) {
      res = _handleAuthErrors(context, e);
    } catch (err) {
      res = "An error occurred: $err";
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
      final validation = await _validateInputs(
        context: context,
        email: email,
        password: password,
      );
      if (validation != "valid") return validation;

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppHelpers.showSnackBar(context, "Logged in successfully!");
      res = "success";
    } on FirebaseAuthException catch (e) {
      res = _handleAuthErrors(context, e);
    } catch (err) {
      res = "An error occurred: $err";
    }
    return res;
  }

  Future<Map<String, dynamic>?> loginWithGoogle({required context}) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        saveUserData(user);
        return {
          'name': user.displayName,
          'email': user.email,
          'profilePicture': user.photoURL,
          'uid': user.uid,
        };
      }
    } catch (err) {
      AppHelpers.showSnackBar(context, "Google Login Failed: $err");
    }
    return null;
  }

  Future<Map<String, dynamic>?> loginWithFacebook({required context}) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Optionally, get additional user data from Facebook
          final userData = await FacebookAuth.instance.getUserData(
            fields: "name,email,picture.width(200)",
          );
          saveUserData(user);
          return {
            'name': userData['name'],
            'email': userData['email'],
            'profilePicture': userData['picture']['data']['url'],
            'uid': user.uid,
          };
        }
      } else if (result.status == LoginStatus.cancelled) {
        AppHelpers.showSnackBar(context, "Facebook Login Cancelled");
      } else {
        AppHelpers.showSnackBar(
            context, "Facebook Login Failed: ${result.message}");
      }
    } catch (err) {
      AppHelpers.showSnackBar(context, "Facebook Login Error: $err");
    }
    return null;
  }

  Future<void> saveUserData(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'name': user.displayName,
      'email': user.email,
      'profilePicture': user.photoURL,
    });
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

  String _handleAuthErrors(context, FirebaseAuthException e) {
    final errorMessages = {
      'user-not-found': "No user found with that email.",
      'wrong-password': "Incorrect password. Please try again.",
      'invalid-credential':
          "The credential is incorrect, malformed, or expired.",
      'email-already-in-use': "The email is already in use by another account.",
      'invalid-email': "The email address is badly formatted.",
      'user-disabled':
          "This account has been disabled. Please contact support.",
      'too-many-requests': "Too many login attempts. Try again later.",
      'operation-not-allowed': "Server error, please try again later.",
      'weak-password': "Password is too weak. Please use a stronger one.",
    };

    final message =
        errorMessages[e.code] ?? e.message ?? "Login failed. Please try again.";

    AppHelpers.showSnackBar(context, message);
    return message;
  }
}
