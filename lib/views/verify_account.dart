import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class EmailVerificationScreen extends StatefulWidget {
  EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _auth = FirebaseAuth.instance;

  late Timer _timer;

  Future<void> checkEmailVerified(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 5));
    await _auth.currentUser?.reload();

    if (_auth.currentUser?.emailVerified ?? false) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Wait a bit so user sees the loader
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) {
        GoRouter.of(context).pop();
        GoRouter.of(context).push('/home');
        pref.setString('token', _auth.currentUser!.uid);
      }
    }
  }

  @override
  void initState() {
    checkEmailVerified(context);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            expandedHeight: 100,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text('Verify Your Email'),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 80,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "A verification link has been sent to your email.",
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Please check your inbox and click the link to verify your email address.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _auth.currentUser!
                          .sendEmailVerification()
                          .then((value) {
                            // TODO: Handle success
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Verification email sent."),
                              ),
                            );
                          })
                          .onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                          });
                      // TODO: Trigger resend verification logic
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Resend Verification Email"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      // TODO: Check email verification status
                    },
                    child: const Text("Already verified? Continue"),
                  ),
                  TextButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove('token');
                      await _auth.signOut();
                      GoRouter.of(context).go('/login');
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
