import 'package:flutter/material.dart';
import 'package:registra/services/auth_services.dart';
import 'package:toastification/toastification.dart';
import 'package:registra/login and register/login.dart';

class ForgPassPage extends StatefulWidget {
  const ForgPassPage({super.key});

  @override
  State<ForgPassPage> createState() => _ForgPassPageState();
}

class _ForgPassPageState extends State<ForgPassPage> {
  final passcont = TextEditingController();
  final cpasscont = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool isLoading = false;

  void showMessage(
    String title,
    String description, {
    ToastificationType type = ToastificationType.error,
  }) {
    toastification.show(
      context: context,
      title: Text(title),
      description: Text(description),
      type: type,
      backgroundColor: const Color(0xFFF7F8F0),
      foregroundColor: const Color(0xff355782),
      showProgressBar: true,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  Future<void> resetPassword() async {
    if (isLoading) return;

    final password = passcont.text;
    final confirmPassword = cpasscont.text;

    if (password.isEmpty) {
      showMessage("Password required", "Please enter a new password.");
      return;
    }

    if (password.length < 6) {
      showMessage(
        "Password too short",
        "Password must contain at least 6 characters.",
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      showMessage("Confirm your password", "Please enter your password again.");
      return;
    }

    if (password != confirmPassword) {
      showMessage(
        "Passwords don't match",
        "Please make sure both passwords are the same.",
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService().updatePassword(password);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(passwordResetSuccess: true),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      final error = e.toString().toLowerCase();

      if (error.contains("request_timeout") || error.contains("timeout")) {
        showMessage(
          "Request timeout",
          "The request took too long. Please try again.",
        );
      } else if (error.contains("errno = 11001") ||
          error.contains("socketexception") ||
          error.contains("network")) {
        showMessage(
          "No internet connection",
          "Please check your internet connection and try again.",
        );
      } else if (error.contains("session") ||
          error.contains("auth session missing") ||
          error.contains("jwt")) {
        showMessage(
          "Session expired",
          "Please request a new password reset link and try again.",
        );
      } else if (error.contains("same_password") ||
          error.contains("new password should be different")) {
        showMessage(
          "Password not changed",
          "Your new password must be different from your old password.",
        );
      } else if (error.contains("password")) {
        showMessage(
          "Password update failed",
          "Unable to update your password. Please try again.",
        );
      } else {
        showMessage(
          "Something went wrong",
          "Unable to update your password. Please try again.",
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    required VoidCallback onVisibilityPressed,
    required bool obscure,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: style(size: 13, clr: Colors.grey.shade500),
      filled: true,
      fillColor: const Color(0xffEEF4F7),
      prefixIcon: Icon(icon, color: const Color(0xff355872), size: 21),
      suffixIcon: IconButton(
        onPressed: onVisibilityPressed,
        icon: Icon(
          obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          color: const Color(0xff355872),
          size: 21,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xff355872), width: 1.5),
      ),
    );
  }

  @override
  void dispose() {
    passcont.dispose();
    cpasscont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;

    final horizontalPadding = screenWidth < 360 ? 16.0 : 22.0;

    final cardWidth = screenWidth > 600 ? 500.0 : double.infinity;

    final topSpacing = screenHeight < 700 ? 8.0 : 22.0;

    final iconSize = screenWidth < 360 ? 58.0 : 68.0;

    final titleSize = screenWidth < 360 ? 22.0 : 25.0;

    return Scaffold(
      backgroundColor: const Color(0xff9CD5FF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: screenHeight < 650 ? 48 : 56,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth < 360 ? 6 : 12),
            child: IconButton(
              onPressed: isLoading
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            topSpacing,
            horizontalPadding,
            30,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: cardWidth),
              child: Column(
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8F0),
                      shape: BoxShape.circle
                    ),
                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: screenWidth < 360 ? 28 : 32,
                      color: const Color(0xff355872),
                    ),
                  ),
                  SizedBox(height: screenHeight < 700 ? 14 : 18),
                  Text(
                    "Reset your password",
                    textAlign: TextAlign.center,
                    style: style(size: titleSize, ft: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Create a new password for your\nRegistra account",
                    textAlign: TextAlign.center,
                    style: style(
                      size: screenWidth < 360 ? 12 : 14,
                      clr: const Color(0xff355872),
                    ),
                  ),
                  SizedBox(height: screenHeight < 700 ? 20 : 28),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenWidth < 360 ? 17 : 22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8F0),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New Password",
                          style: style(
                            ft: FontWeight.w600,
                            size: screenWidth < 360 ? 14 : 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: passcont,
                          obscureText: obscurePassword,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) {
                            setState(() {});
                          },
                          decoration: inputDecoration(
                            hint: "Enter your new password",
                            icon: Icons.lock_outline_rounded,
                            obscure: obscurePassword,
                            onVisibilityPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              passcont.text.length >= 6
                                  ? Icons.check_circle_rounded
                                  : Icons.info_outline_rounded,
                              size: 15,
                              color: passcont.text.length >= 6
                                  ? Colors.green
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                passcont.text.length >= 6
                                    ? "Minimum 6 characters"
                                    : "${passcont.text.length}/6 characters",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: passcont.text.length >= 6
                                      ? Colors.green
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight < 700 ? 17 : 22),
                        Text(
                          "Confirm Password",
                          style: style(
                            ft: FontWeight.w600,
                            size: screenWidth < 360 ? 14 : 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: cpasscont,
                          obscureText: obscureConfirm,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          onChanged: (_) {
                            setState(() {});
                          },
                          onSubmitted: (_) {
                            resetPassword();
                          },
                          decoration: inputDecoration(
                            hint: "Enter your password again",
                            icon: Icons.lock_outline_rounded,
                            obscure: obscureConfirm,
                            onVisibilityPressed: () {
                              setState(() {
                                obscureConfirm = !obscureConfirm;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (cpasscont.text.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                passcont.text == cpasscont.text
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                size: 15,
                                color: passcont.text == cpasscont.text
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  passcont.text == cpasscont.text
                                      ? "Passwords match"
                                      : "Passwords don't match",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: passcont.text == cpasscont.text
                                        ? Colors.green
                                        : Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: screenHeight < 700 ? 22 : 28),
                        SizedBox(
                          width: double.infinity,
                          height: screenWidth < 360 ? 48 : 52,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : resetPassword,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xff355782),
                              foregroundColor: const Color(0xFFF7F8F0),
                              disabledBackgroundColor: const Color(
                                0xff355782,
                              ).withOpacity(0.7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: isLoading
                                  ? const SizedBox(
                                      key: ValueKey("loading"),
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        color: Color(0xFFF7F8F0),
                                      ),
                                    )
                                  : Text(
                                      "Continue",
                                      key: const ValueKey("continue"),
                                      style: style(
                                        size: 15,
                                        ft: FontWeight.w600,
                                        clr: const Color(0xFFF7F8F0),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Your password should contain at least 6 characters.",
                    textAlign: TextAlign.center,
                    style: style(size: 11, clr: const Color(0xff355872)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
