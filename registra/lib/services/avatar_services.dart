import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
final presetAvatars = [
       'presets/preset1.jpeg',  
       'presets/preset2.jpeg', 
       'presets/preset3.jpeg', 
       'presets/preset4.jpeg', 
       'presets/preset5.jpeg', 
       'presets/preset6.jpeg', 
       'presets/preset7.jpeg', 
       'presets/preset8.jpeg', 
       'presets/preset9.jpeg', 
       'presets/preset10.jpeg', 
       'presets/preset11.jpeg', 
       'presets/preset12.jpeg', 
       'presets/preset13.jpeg', 
       'presets/preset14.jpeg', 
       'presets/preset15.jpeg',  
  ];
class AvatarServices {

  final ImagePicker imagepicker = ImagePicker();
  Future<File?> pickImage() async {
    final image = await imagepicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null) return null;
    return File(image.path);
  }

  Future<String?> uploadAvatar(File image) async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final path = "${user.id}/avatar.jpg";

    try {
  await supabase.storage
      .from('avatar')
      .upload(
        path,
        image,
        fileOptions: const FileOptions(upsert: true),
      );
} catch (e, st) {
  print(e);
  print(st);
}
    await supabase
        .from('profiles')
        .update({
          'avatar_type':"uploaded",
          'avatar_path': path})
        .eq('id', user.id);
    return path;
  }
  Future<void> selectPreset(String path) async {
    final user = supabase.auth.currentUser!;
    await supabase.from("profiles").update({
    "avatar_type":"preset",
    "avatar_path":path
    })
    .eq("id", user.id);
  }
  Future<Map<String, dynamic>> getAvatar() async {
  final user = supabase.auth.currentUser!;

  final data = await supabase
      .from("profiles")
      .select("avatar_type, avatar_path")
      .eq("id", user.id)
      .single();

  return data;
}
}
