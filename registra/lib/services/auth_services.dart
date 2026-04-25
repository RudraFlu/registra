import 'package:flutter/painting.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthService {
  final supabase = Supabase.instance.client;

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

  Future<void> signOut()async{
    await supabase.auth.signOut();
  }

  User? get currentUser =>supabase.auth.currentUser;
  bool get isLogged => supabase.auth.currentSession != null;
}
TextStyle stly({Color clr=const Color(0xFF355782),double size=16}){
  return GoogleFonts.poppins(
  textStyle: TextStyle(color: clr, fontSize: size),
);
}