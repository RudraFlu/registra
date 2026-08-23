import 'package:registra/services/auth_services.dart';
import 'dart:math';
class ProfileService {
Future<bool> usernameAvailable(String username) async {
  final result = await supabase
      .from('profiles')
      .select('username')
      .eq('username', username)
      .maybeSingle();

  return result == null;
}
Future<void> createProfile({
  required String displayName,
  required String username,
}) async {
  final user = supabase.auth.currentUser;

  if (user == null) {
    throw Exception("No authenticated user found.");
  }

  await supabase.from('profiles').insert({
    'id': user.id,
    'display_name': displayName.trim(),
    'username': username.trim().toLowerCase()
  });
}
Future<bool> profileExists() async {
  final user = supabase.auth.currentUser;

  if (user == null) return false;

  final profile = await supabase
      .from('profiles')
      .select('id')
      .eq('id', user.id)
      .maybeSingle();

  return profile != null;
}
Future<Map<String, dynamic>?> getProfile() async {
  final user = supabase.auth.currentUser;

  if (user == null) return null;

  final profile = await supabase
      .from('profiles')
      .select()
      .eq('id', user.id)
      .single();

  return profile;
}
Future<String> generateAvailableUsername() async {
  while (true) {
    final username = UserIDGen.randomUsername();

    final available = await usernameAvailable(username);

    if (available) {
      return username.toString();
    }
  }
}
}
class UserIDGen{
  static final Random random = Random();

  static const List<String> adj = [
    "smart",
    "silent",
    "rapid",
    "blue",
    "silver",
    "happy",
    "tiny",
    "cute",
    "brave",
    "sour",
    "sweety",
    "hidden",
    "swift",
    "calm",
    "bright",
    "clever",
    "lucky",
    "sad",
    "plumpy",
    "skibidi"
  ];
   static const List<String> nouns = [
    "wallet",
    "coin",
    "ledger",
    "carrot",
    "lemon",
    "panda",
    "fox",
    "wolf",
    "falcon",
    "grape",
    "mango",
    "tiger",
    "bear",
    "owl",
    "pilot",
    "keeper",
    "hawk",
    "toilet",
    "watermelon",
    "orange",
    "cucumber",
    "cabbage",
    "strawberry",
    "berry"
  ];
  static String randomUsername() {
    return "${adj[random.nextInt(adj.length)]}"
        "${nouns[random.nextInt(nouns.length)]}"
        "${100+random.nextInt(900)}";
  }
}