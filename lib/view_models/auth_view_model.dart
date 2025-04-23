// sign_up_notifier.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth_model.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpNotifier extends StateNotifier<SignUpFormState> {
  SignUpNotifier() : super(SignUpFormState());

  final _auth = FirebaseAuth.instance;

  // Set the email
  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  // Set the password
  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  // Set the confirm password
  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  // Validate form
  String? validateEmail(String value) {
    if (value.isEmpty) return 'Please enter an email address';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password should be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value != state.password) return 'Passwords do not match';
    return null;
  }

  // Submit form
  Future<void> submitForm() async {
    // Trigger validation
    final emailError = validateEmail(state.email);
    final passwordError = validatePassword(state.password);
    final confirmPasswordError = validateConfirmPassword(state.confirmPassword);

    if (emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      state = state.copyWith(errorMessage: 'Please fix the errors');
      return;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: '');

    try {
      await _auth.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );

      // On success
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        errorMessage: '',
      );
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again.';

      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is invalid.';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak.';
      }

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: message,
      );
    } catch (e) {
      debugPrint(e.toString());
      // Generic error
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> submitLogin(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Trigger validation
    final emailError = validateEmail(state.email);
    final passwordError = validatePassword(state.password);

    if (emailError != null || passwordError != null) {
      state = state.copyWith(errorMessage: 'Please fix the errors');
      return;
    }

    // Start login process
    state = state.copyWith(isSubmitting: true, errorMessage: '');

    try {
      await _auth.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );

      // On success
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        errorMessage: '',
      );

      GoRouter.of(context).push('/home');

      preferences.setString('token', _auth.currentUser!.uid);

    } on FirebaseAuthException catch (e) {
      String message = 'Login failed. Please try again.';
      debugPrint(e.code);
      if (e.code == 'invalid-credential') {
        message = 'Email or password is Wrong.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is invalid.';
      }

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: message,
      );
    } catch (e) {
      // Other errors
      debugPrint(e.toString());
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: 'Something went wrong. Please try again later.',
      );
    }
  }
}
