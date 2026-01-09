import 'package:climate_sense/screens/signin_screen.dart';
import 'package:climate_sense/widgets/google_login_button.dart';
import 'package:climate_sense/widgets/text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _nameShakeController;
  late AnimationController _emailShakeController;
  late AnimationController _passwordShakeController;
  late AnimationController _confirmPasswordShakeController;

  late Animation<double> _nameShakeAnimation;
  late Animation<double> _emailShakeAnimation;
  late Animation<double> _passwordShakeAnimation;
  late Animation<double> _confirmPasswordShakeAnimation;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

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

    _nameShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _emailShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _passwordShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _confirmPasswordShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _nameShakeAnimation = _buildShakeAnimation(_nameShakeController);
    _emailShakeAnimation = _buildShakeAnimation(_emailShakeController);
    _passwordShakeAnimation = _buildShakeAnimation(_passwordShakeController);
    _confirmPasswordShakeAnimation = _buildShakeAnimation(
      _confirmPasswordShakeController,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameShakeController.dispose();
    _emailShakeController.dispose();
    _passwordShakeController.dispose();
    _confirmPasswordShakeController.dispose();
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
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        Center(
                          child: const Text(
                            'Create your account',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Name TextField
                        FormFieldBox(
                          placeholder: 'Enter Full Name',
                          textController: _nameController,
                          shakeAnimation: _nameShakeAnimation,
                          fieldError: _nameError,
                          validationLogic: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _nameError = 'Name cannot be empty';
                              });
                              return "";
                            }
                            if (value.length < 2) {
                              setState(() {
                                _nameError =
                                    'Name must be at least 2 characters';
                              });
                              return "";
                            }
                            setState(() {
                              _nameError = null;
                            });
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        FormFieldBox(
                          placeholder: 'Enter Email',
                          textController: _emailController,
                          shakeAnimation: _emailShakeAnimation,
                          fieldError: _emailError,
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

                        // Email TextField
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
                            if (value.length < 6) {
                              setState(() {
                                _passwordError =
                                    'Password must be at least 6 characters';
                              });
                              return "";
                            }
                            setState(() {
                              _passwordError = null;
                            });
                            return null;
                          },
                          onToggleVisibility: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        // Confirm Password TextField
                        FormFieldBox(
                          textController: _confirmPasswordController,
                          shakeAnimation: _confirmPasswordShakeAnimation,
                          fieldError: _confirmPasswordError,
                          placeholder: "Confirm Password",
                          isPassword: true,
                          obscureText: !_isConfirmPasswordVisible,
                          validationLogic: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _confirmPasswordError =
                                    'Please confirm your password';
                              });
                              return "";
                            }
                            if (value != _passwordController.text) {
                              setState(() {
                                _confirmPasswordError =
                                    'Passwords do not match';
                              });
                              return "";
                            }
                            setState(() {
                              _confirmPasswordError = null;
                            });
                            return null;
                          },
                          onToggleVisibility: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),

                        const SizedBox(height: 60),

                        // Register Button
                        ElevatedButton(
                          onPressed: () {
                            // Register action
                            final isValid = _formKey.currentState!.validate();

                            if (!isValid) {
                              if (_nameError != null) {
                                _nameShakeController.forward(from: 0);
                              }
                              if (_emailError != null) {
                                _emailShakeController.forward(from: 0);
                              }
                              if (_passwordError != null) {
                                _passwordShakeController.forward(from: 0);
                              }
                              if (_confirmPasswordError != null) {
                                _confirmPasswordShakeController.forward(
                                  from: 0,
                                );
                              }
                              return;
                            }

                            // ✅ All validations passed
                            final name = _nameController.text.trim();
                            final email = _emailController.text.trim();
                            final password = _passwordController.text;

                            // TODO: call register API
                            print('Name: $name');
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
                            'Register',
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

                        // Sign In text
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(text: 'Have an account? '),
                                TextSpan(
                                  text: 'SIGN IN',
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
                                              const SignInScreen(),
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
