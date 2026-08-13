import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:registra/login%20and%20register/profile.dart';
import 'package:registra/services/auth_services.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String pass;
  const OtpScreen(this.email, this.pass, {super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpCont = TextEditingController();
  final auth = AuthService();
  bool isLoading = false;
  int resendTime = 90;

  Timer? resendTimer;
  void startResendTimer() {
    resendTimer?.cancel();
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTime == 0) {
        timer.cancel();
      } else {
        setState(() {
          resendTime--;
        });
      }
    });
  }
 
  @override
void initState() {
  super.initState();
  startResendTimer();
}

  @override
  void dispose() {
    resendTimer?.cancel();
    super.dispose();
  }

  Future<void> handleOtp(String pin) async {
    setState(() => isLoading = true);

    final error = await auth.verifyOtp(widget.email, pin);

    if (mounted) {
      setState(() => isLoading = false);
    } else {
      return;
    }
    if (error != null) {
      if (error.contains("otp_expired")) {
        toastification.show(
          context: context,
          title: Text("Invalid OTP"),
          description: Text(
            "Given OTP has either expired or is invalid, please try again",
          ),
          type: ToastificationType.error,
          backgroundColor: Color(0xFFF7F8F0),
          foregroundColor: Color(0xFF355782),
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else if (error.contains("request_timeout")) {
        toastification.show(
          autoCloseDuration: Duration(seconds: 3),
          context: context,
          foregroundColor: Color(0xFF355782),
          type: ToastificationType.error,
          title: Text("Request timeout"),
          description: Text("Request took too long, please try again later"),
        );
      } else if (error.contains("errno = 11001")) {
        toastification.show(
          autoCloseDuration: Duration(seconds: 3),
          context: context,
          foregroundColor: Color(0xFF355782),
          type: ToastificationType.error,
          title: Text("No internet connection"),
          description: Text("Cannot access internet"),
        );
      } else if (error.contains("over_email_send_rate_limit")) {
        toastification.show(
          autoCloseDuration: Duration(seconds: 3),
          context: context,
          foregroundColor: Color(0xFF355782),
          style: ToastificationStyle.minimal,
          type: ToastificationType.warning,
          title: Text("Cannot resend otp immediately"),
          description: Text("Please try after some time"),
        );
      } else if (error.contains("email rate limit exceeded")) {
        toastification.show(
          autoCloseDuration: Duration(seconds: 3),
          context: context,
          foregroundColor: Color(0xFF355782),
          style: ToastificationStyle.minimal,
          type: ToastificationType.error,
          title: Text("Email rate limit exceeded"),
          description: Text("please try again later"),
        );
      } else {
        toastification.show(
          context: context,
          description: Text(error.toString()),
          type: ToastificationType.error,
          backgroundColor: Color(0xFFF7F8F0),
          foregroundColor: Color(0xFF355782),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
      otpCont.clear();
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => ProfilePage()),
        (route) => false,
      );
    }
  }

  Future<void> handleResendOtp() async {
    final e = await auth.resendOtp(widget.email);
    if (!mounted) {
      return;
    }
    if (e != null) {
      startResendTimer();
      toastification.show(
        context: context,
        title: Text(e),
        type: ToastificationType.error,
        backgroundColor: Color(0xFFF7F8F0),
        foregroundColor: Color(0xFF355782),
        autoCloseDuration: const Duration(seconds: 3),
      );
    } else {
      startResendTimer();
      toastification.show(
        context: context,
        title: Text('Otp resent!'),
        description: Text('New otp sent to your email: ${widget.email}'),
        type: ToastificationType.success,
        backgroundColor: Color(0xFFF7F8F0),
        foregroundColor: Color(0xFF355782),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F8F0),
      body: Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff9CD5FF), Color(0xffF7F8F0)],
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Center(
              child: SizedBox(
                width: 300,
                height: 150,
                child: Image.asset("assets/images/otp.png"),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "an OTP is sent to ",
                  style: style(size: 15),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${widget.email}",
                          style: style(size: 15),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.edit_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                "please enter it for verification",
                style: style(size: 15),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Pinput(
                length: 6,
                controller: otpCont,
                onCompleted: (pin) => handleOtp(pin),
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    color: Color(0xff355782),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xff9CD5FF),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    color: Color(0xfff7f8f0),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xff355782),
                  ),
                ),
                animationCurve: Curves.bounceIn,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              child: Text(
                "Didn't receive code?",
                style: GoogleFonts.poppins(textStyle: style(size: 14)),
              ),
            ),

            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: OutlinedButton(
                onPressed: resendTime == 0 ? handleResendOtp : null,
                child: Text(
                  resendTime == 0 ? 'Resend' : 'Resend in ${resendTime}s',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
