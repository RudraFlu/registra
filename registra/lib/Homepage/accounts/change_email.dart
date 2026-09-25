import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:registra/services/auth_services.dart';
import 'package:registra/services/profile_service.dart';
import 'package:toastification/toastification.dart';

class ChangeEmailPage extends StatefulWidget {
  final String currentEmail;

  const ChangeEmailPage({super.key, required this.currentEmail});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final AuthService authService = AuthService();
  final ProfileService profService = ProfileService();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();

  bool loading = false;
  bool hidePassword = true;
  bool resendingOtp = false;
  int step = 0;
  Future<void> resendEmailOtp() async {
    setState(() {
      resendingOtp = true;
    });

    try {
      final error = await authService.resendOtp(
        emailController.text.trim(),
        emailChange: true,
      );

      if (!mounted) return;

      if (error != null) {
        showMessage("Something went wrong", error, error: true);
        return;
      }

      showMessage("Resend successful", "A new OTP has been sent.");
    } finally {
      if (mounted) {
        setState(() {
          resendingOtp = false;
        });
      }
    }
  }

  Future<void> verifyPassword() async {
    final password = passwordController.text.trim();

    if (password.isEmpty) {
      showMessage("Enter Password", "Please enter your password", error: true);
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final error = await authService.reauthenticate(password);

      if (!mounted) return;

      if (error != null) {
        showMessage(
          "Incorrect password",
          "Please enter valid password",
          error: true,
        );
        return;
      }

      setState(() {
        step = 1;
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> sendEmailChange() async {
    final newEmail = emailController.text.trim();

    if (newEmail.isEmpty) {
      showMessage("Enter new email", "Please enter a new email", error: true);
      return;
    }

    if (newEmail == widget.currentEmail) {
      showMessage(
        "Same as old",
        "New email is the same as your current email",
        error: true,
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final error = await authService.updateEmail(newEmail);

      if (!mounted) return;

      if (error != null) {
        if (error.contains("request_timeout")) {
          toastification.show(
            autoCloseDuration: Duration(seconds: 3),
            context: context,
            showProgressBar: true,
            foregroundColor: Color(0xFF355782),
            type: ToastificationType.error,
            title: Text("Request timeout"),
            description: Text("Request took too long, please try again later"),
          );
        } else if (error.contains("errno = 11001")) {
          toastification.show(
            autoCloseDuration: Duration(seconds: 3),
            context: context,
            showProgressBar: true,
            foregroundColor: Color(0xFF355782),
            type: ToastificationType.error,
            title: Text("No internet connection"),
            description: Text("Cannot access internet"),
          );
        } else if (error.contains("email rate limit exceeded")) {
          toastification.show(
            autoCloseDuration: Duration(seconds: 3),
            context: context,
            foregroundColor: Color(0xFF355782),
            showProgressBar: true,
            style: ToastificationStyle.minimal,
            type: ToastificationType.error,
            title: Text("Email rate limit exceeded"),
            description: Text("please try again later"),
          );
        } else if (error.contains("over_email_send_rate_limit")) {
          toastification.show(
            autoCloseDuration: Duration(seconds: 3),
            context: context,
            foregroundColor: Color(0xFF355782),
            style: ToastificationStyle.minimal,
            showProgressBar: true,
            type: ToastificationType.warning,
            title: Text("Cannot resend otp immediately"),
            description: Text("Please try after some time"),
          );
        } else {
          showMessage("Something went wrong", error, error: true);
        }
        return;
      }

      setState(() {
        step = 2;
      });

      showMessage(
        "OTP sent successfully",
        "Verification OTP sent to your new email",
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    final newEmail = emailController.text.trim();

    if (otp.isEmpty) {
      showMessage("Enter OTP", "Please enter the OTP", error: true);
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final error = await authService.verifyEmailChangeOtp(newEmail, otp);

      if (!mounted) return;

      if (error != null) {
        showMessage(
          "Invalid OTP",
          "Entered OTP is either expired or invalid",
          error: true,
        );
        return;
      }
      await profService.updateEmail(newEmail);
      showMessage("Successful", "Email changed successfully");

      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void showMessage(String text, String message, {bool error = false}) {
    toastification.show(
      context: context,
      type: error ? ToastificationType.warning : ToastificationType.success,
      style: ToastificationStyle.minimal,
      title: Text(text),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Email")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            if (step == 0) ...[
              Text(
                "Enter your current password",
                style: style(size: 20, ft: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "Verify your password before changing your email.",
                style: style(size: 14, clr: Colors.grey.shade600),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  hintText: "Current password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: loading ? null : verifyPassword,
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Color(0xff355872),
                        )
                      : Text("Continue", style: style()),
                ),
              ),
            ],

            if (step == 1) ...[
              Text(
                "Enter your new email",
                style: style(size: 20, ft: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "A verification code will be sent to this email.",
                style: style(size: 14, clr: Colors.grey.shade600),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "New email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: loading ? null : sendEmailChange,
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Color(0xff355872),
                        )
                      : Text("Send OTP", style: style()),
                ),
              ),
            ],

            if (step == 2) ...[
              Text(
                "Verify your new email",
                style: style(size: 20, ft: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "Enter the OTP sent to:",
                style: style(size: 14, clr: Colors.grey.shade600),
              ),

              const SizedBox(height: 4),

              Text(
                emailController.text,
                style: style(size: 15, ft: FontWeight.w600),
              ),

              const SizedBox(height: 25),
              Center(
                child: TextButton(
                  onPressed: resendingOtp ? null : resendEmailOtp,
                  child: resendingOtp
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2,color: Color(0xff355872),),
                        )
                      : const Text("Resend OTP"),
                ),
              ),
              Pinput(
                controller: otpController,
                length: 6,
                keyboardType: TextInputType.number,
                onCompleted: (value) {
                  if (!loading) {
                    verifyOtp();
                  }
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: loading ? null : verifyOtp,
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Color(0xff355872),
                        )
                      : Text("Verify OTP", style: style()),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
