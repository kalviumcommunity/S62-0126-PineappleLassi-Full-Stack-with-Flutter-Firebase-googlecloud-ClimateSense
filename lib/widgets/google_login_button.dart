import 'package:climate_sense/features/auth/logic/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoogleLoginButton extends ConsumerStatefulWidget {
  final bool enabled;
  final void Function(bool isLoading) setIsLoading;
  final void Function(String message) setErrorMessage;

  const GoogleLoginButton({
    super.key,
    required this.enabled,
    required this.setIsLoading,
    required this.setErrorMessage,
  });

  @override
  ConsumerState<GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends ConsumerState<GoogleLoginButton> {
  Future<void> _googleLogin() async {
    if (!widget.enabled) return;

    widget.setIsLoading(true);
    widget.setErrorMessage("");

    try {
      await ref.read(authServiceProvider).signInWithGoogle();

      if (!mounted) return;
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (er) {
      widget.setErrorMessage(er.message ?? "Unexpected error occurred");
    } finally {
      if (mounted) {
        widget.setIsLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          onPressed: widget.enabled ? _googleLogin : null,
          icon: Image.network(
            'https://www.google.com/favicon.ico',
            width: 32,
            height: 32,
          ),
        ),
      ),
    );
  }
}
