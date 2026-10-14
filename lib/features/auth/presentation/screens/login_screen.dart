import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Call authentication controller
    await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    // Make sure widget is still mounted
    if (!mounted) {
      return;
    }

    // Get latest authentication state
    final authState = ref.read(authControllerProvider);

    // Handle error
    if (authState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authState.error.toString(),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    // Login successful
    if (authState.value == true) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(
      authControllerProvider,
    );

    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 40),

                    _buildLoginCard(
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.1),
            borderRadius:
                BorderRadius.circular(18),
          ),
          child: Icon(
            Icons.newspaper_rounded,
            size: 34,
            color: Theme.of(context)
                .colorScheme
                .primary,
          ),
        ),

        const SizedBox(height: 28),

        Text(
          'Welcome back',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(
                fontWeight:
                    FontWeight.w700,
              ),
        ),

        const SizedBox(height: 8),

        Text(
          'Stay informed with the latest business and market news.',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _buildLoginCard({
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: const Offset(0, 10),
            color: Colors.black
                .withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Sign in',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  fontWeight:
                      FontWeight.w700,
                ),
          ),

          const SizedBox(height: 6),

          Text(
            'Enter your credentials to continue.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  color:
                      Colors.grey.shade600,
                ),
          ),

          const SizedBox(height: 28),

          Text(
            'Email address',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(
                  fontWeight:
                      FontWeight.w600,
                ),
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller:
                _emailController,
            keyboardType:
                TextInputType.emailAddress,
            textInputAction:
                TextInputAction.next,
            enabled: !isLoading,

            decoration:
                const InputDecoration(
              hintText:
                  'Enter your email',
              prefixIcon: Icon(
                Icons.email_outlined,
              ),
            ),

            validator: (value) {
              final email =
                  value?.trim() ?? '';

              if (email.isEmpty) {
                return 'Please enter your email';
              }

              final emailRegex =
                  RegExp(
                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
              );

              if (!emailRegex
                  .hasMatch(email)) {
                return 'Please enter a valid email';
              }

              return null;
            },
          ),

          const SizedBox(height: 20),

          Text(
            'Password',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(
                  fontWeight:
                      FontWeight.w600,
                ),
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller:
                _passwordController,
            obscureText:
                _obscurePassword,
            textInputAction:
                TextInputAction.done,
            enabled: !isLoading,

            onFieldSubmitted: (_) {
              if (!isLoading) {
                _login();
              }
            },

            decoration:
                InputDecoration(
              hintText:
                  'Enter your password',
              prefixIcon:
                  const Icon(
                Icons
                    .lock_outline_rounded,
              ),
              suffixIcon:
                  IconButton(
                onPressed: isLoading
                    ? null
                    : () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword;
                        });
                      },
                icon: Icon(
                  _obscurePassword
                      ? Icons
                          .visibility_outlined
                      : Icons
                          .visibility_off_outlined,
                ),
              ),
            ),

            validator: (value) {
              if (value == null ||
                  value.isEmpty) {
                return 'Please enter your password';
              }

              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }

              return null;
            },
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed:
                  isLoading ? null : _login,

              child: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Sign in',
                      style:
                          TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              'Demo authentication',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    color:
                        Colors.grey.shade500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}