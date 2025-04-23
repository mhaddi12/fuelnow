import 'dart:math';

import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_model.dart';
import '../providers/auth_provider.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/custom_animated_icon.dart';
import '../widgets/custom_text_field.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(signUpNotifierProvider);
    final notifier = ref.read(signUpNotifierProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.25),
                        theme.colorScheme.surface,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoAnimatedIcon(
                          firstIcon: Icons.person_outline,
                          secondIcon: Icons.person,
                          color: Colors.deepPurple,
                          size: 50,
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (child, animation) => ScaleTransition(
                                scale: animation,
                                child: child,
                              ), // custom animation
                        ),

                        const SizedBox(height: 12),
                        Text(
                          "Welcome",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Let’s get you registered.",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black.withOpacity(0.05),
                    //     blurRadius: 20,
                    //     offset: const Offset(0, 10),
                    //   ),
                    // ],
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.15),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          initialValue: formState.email,
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: notifier.setEmail,
                          validator:
                              (value) => notifier.validateEmail(value ?? ''),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          initialValue: formState.password,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: true,
                          onChanged: notifier.setPassword,
                          validator:
                              (value) => notifier.validatePassword(value ?? ''),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          initialValue: formState.confirmPassword,
                          label: 'Confirm Password',
                          icon: Icons.lock_reset_rounded,
                          obscureText: true,
                          onChanged: notifier.setConfirmPassword,
                          validator:
                              (value) =>
                                  notifier.validateConfirmPassword(value ?? ''),
                        ),
                        const SizedBox(height: 30),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: SizedBox(
                            width: double.infinity,
                            key: ValueKey(formState.isSubmitting),
                            child: ElevatedButton.icon(
                              icon:
                                  formState.isSubmitting
                                      ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Icon(Icons.arrow_forward_rounded),
                              label: Text(
                                formState.isSubmitting
                                    ? 'Signing Up...'
                                    : 'Create Account',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed:
                                  formState.isSubmitting
                                      ? null
                                      : () {
                                        if (_formKey.currentState!.validate()) {
                                          notifier.submitForm();
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: theme.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// Feedback message
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      formState.errorMessage.isNotEmpty
                          ? Container(
                            key: const ValueKey('error'),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              formState.errorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                          : formState.isSuccess
                          ? Container(
                            key: const ValueKey('success'),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green),
                            ),
                            child: const Text(
                              'Signup successful! 🎉',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("already have an account?", style: theme.textTheme.bodySmall),
                  TextButton(onPressed: () {
                    context.push('/login');
                  }, child: const Text("Login")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
