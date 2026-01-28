import 'package:flutter/material.dart';

class FormFieldBox extends StatelessWidget {
  final String placeholder;
  final TextEditingController textController;
  final Animation<double> shakeAnimation;
  final String? fieldError;
  final String? Function(String? value) validationLogic;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final bool enabled;

  const FormFieldBox({
    super.key,
    required this.textController,
    required this.shakeAnimation,
    required this.fieldError,
    required this.placeholder,
    required this.validationLogic,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(shakeAnimation.value, 0),
              child: child,
            );
          },
          child: Container(
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
            child: TextFormField(
              enabled: enabled,
              controller: textController,
              obscureText: isPassword ? obscureText : false,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                errorStyle: const TextStyle(height: 0, fontSize: 0),
                errorMaxLines: 1,
                hintText: placeholder,
                hintStyle: TextStyle(color: Colors.grey.shade900, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey.shade400,
                        ),
                        onPressed: onToggleVisibility,
                      )
                    : ValueListenableBuilder<TextEditingValue>(
                        valueListenable: textController,
                        builder: (context, value, child) {
                          if (value.text.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            icon: const Icon(Icons.cancel_outlined),
                            color: Colors.grey.shade400,
                            onPressed: textController.clear,
                          );
                        },
                      ),
              ),
              validator: (value) {
                return validationLogic(value);
              },
            ),
          ),
        ),
        if (fieldError != null) ...[
          const SizedBox(height: 6),
          Text(
            fieldError!,
            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
