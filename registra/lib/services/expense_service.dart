import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
IconData getIcon(String category) {
  switch (category) {
    case 'food':
      return Icons.local_restaurant;
    case 'transport':
      return Icons.local_taxi;
    case 'shopping':
      return Icons.shopping_bag_outlined;
    case 'entertainment':
      return Icons.movie_creation_outlined;
    case 'bills':
      return Icons.receipt_long_outlined;
    case 'health':
      return Icons.medical_services_outlined;
    default:
      return Icons.category;
  }
}
TextStyle stly = GoogleFonts.poppins(
  textStyle: TextStyle(color: Color(0xFF355872), fontSize: 16),
);

final supabase = Supabase.instance.client;