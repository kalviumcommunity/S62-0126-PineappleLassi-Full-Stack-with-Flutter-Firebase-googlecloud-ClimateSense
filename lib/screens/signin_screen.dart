import 'package:climate_sense/screens/register_screen.dart';
import 'package:climate_sense/widgets/google_login_button.dart';
import 'package:climate_sense/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _emailShakeController;
  late AnimationController _passwordShakeController;

  late Animation<double> _emailShakeAnimation;
  late Animation<double> _passwordShakeAnimation;

  String? _emailError;
  String? _passwordError;

  Animation<double> _buildShakeAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(controller);
  }

  @override
  void initState() {
    super.initState();

    _emailShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _passwordShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _emailShakeAnimation = _buildShakeAnimation(_emailShakeController);
    _passwordShakeAnimation = _buildShakeAnimation(_passwordShakeController);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailShakeController.dispose();
    _passwordShakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade100,
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // App Logo
                        Center(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.cloud_outlined,
                              size: 72,
                              color: Colors.blue.shade600,
                            ),
                            // child: Image.asset(
                            //   'assets/logo.png',
                            //   fit: BoxFit.contain,
                            // ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Title
                        const Text(
                          'Sign In to \nClimateSense',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Email TextField
                        FormFieldBox(
                          textController: _emailController,
                          shakeAnimation: _emailShakeAnimation,
                          fieldError: _emailError,
                          placeholder: 'Enter Email',
                          validationLogic: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _emailError = 'Email cannot be empty';
                              });
                              return "";
                            }
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value)) {
                              setState(() {
                                _emailError = 'Please enter a valid email';
                              });
                              return "";
                            }
                            setState(() {
                              _emailError = null;
                            });
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Password TextField
                        FormFieldBox(
                          textController: _passwordController,
                          shakeAnimation: _passwordShakeAnimation,
                          fieldError: _passwordError,
                          placeholder: "••••••••",
                          isPassword: true,
                          obscureText: !_isPasswordVisible,
                          validationLogic: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _passwordError = 'Password cannot be empty';
                              });
                              return "";
                            }
                            setState(() {
                              _passwordError = null;
                            });
                            return null;
                          },
                        ),

                        const SizedBox(height: 60),

                        // Sign In Button
                        ElevatedButton(
                          onPressed: () {
                            // Sign in action
                            final isValid = _formKey.currentState!.validate();

                            if (!isValid) {
                              if (_emailError != null) {
                                _emailShakeController.forward(from: 0);
                              }
                              if (_passwordError != null) {
                                _passwordShakeController.forward(from: 0);
                              }
                              return;
                            }

                            // ✅ All validations passed
                            final email = _emailController.text.trim();
                            final password = _passwordController.text;

                            // TODO: call login API
                            print('Email: $email');
                            print('Password: $password');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Or continue with
                        Text(
                          'Or continue with',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade900,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Google Login Button
                        GoogleLoginButton(),

                        const SizedBox(height: 20),

                        // Register text
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(text: 'Dont have an account?  '),
                                TextSpan(
                                  text: 'REGISTER',
                                  style: TextStyle(
                                    color: Colors.blue.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
