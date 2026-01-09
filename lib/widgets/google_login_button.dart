import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

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
          onPressed: () {
            // TODO: add google signin logic
            // Google sign in
            print('Google Sign In pressed');
          },
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
