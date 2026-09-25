import 'package:flutter/painting.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

final supabase = Supabase.instance.client;

class AuthService {
  Future<String?> signUp(String email, String password) async {
    try {
      await supabase.auth.signUp(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  User? get currentUser => supabase.auth.currentUser;

  Future<String?> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'registra://reset-password',
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updatePassword(String newPassword) async {
    await supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  Future<String?> updateEmail(String newEmail) async {
    try {
      await supabase.auth.updateUser(UserAttributes(email: newEmail));

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> reauthenticate(String password) async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null || user.email == null) {
        return "No authenticated user found.";
      }

      await supabase.auth.signInWithPassword(
        email: user.email!,
        password: password,
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> verifyEmailChangeOtp(String email, String token) async {
    try {
      await supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.emailChange,
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> resendOtp(String email, {bool emailChange = false}) async {
    try {
      await supabase.auth.resend(
        type: emailChange ? OtpType.emailChange : OtpType.signup,
        email: email,
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> verifyOtp(
  String email,
  String token, {
  bool recovery = false,
}) async {
  try {
    await supabase.auth.verifyOTP(
      email: email,
      token: token,
      type: recovery
          ? OtpType.recovery
          : OtpType.signup,
    );

    return null;
  } catch (e) {
    return e.toString();
  }
}
}

TextStyle style({
  double size = 16,
  FontWeight ft = FontWeight.normal,
  Color clr = const Color(0xff355782),
}) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(color: clr, fontSize: size, fontWeight: ft),
  );
}
