import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
final presetAvatars = [
       'preset1.jpeg',  
       'preset2.jpeg', 
       'preset3.jpeg', 
       'preset4.jpeg', 
       'preset5.jpeg', 
       'preset6.jpeg', 
       'preset7.jpeg', 
       'preset8.jpeg', 
       'preset9.jpeg', 
       'preset10.jpeg', 
       'preset11.jpeg', 
       'preset12.jpeg', 
       'preset13.jpeg', 
       'preset14.jpeg', 
       'preset15.jpeg',  
  ];
class AvatarServices {
  Future<Map<String, dynamic>> getAvatar() async {
  final user = supabase.auth.currentUser!;

  final data = await supabase
      .from("profiles")
      .select("avatar_type, avatar_path")
      .eq("id", user.id)
      .single();

  return data;
}
Future<String> getAvatarUrl(String path) async {
  return await supabase.storage
      .from('avatar-custom')
      .createSignedUrl(path, 3600);
}
Future<File?> pickImage () async{
   final picker = ImagePicker();
   final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 90);
   if (pickedFile == null) return null;
   return File(pickedFile.path);
  }
Future <void> saveAvatarSelection({
  required String avatarType,
  required String avatarPath,
  
}) async {
  final user = supabase.auth.currentUser;
  if(user == null){
    throw Exception("no user found");
  }
  await supabase.from('profiles').update({
    'avatar_type':avatarType,
    'avatar_path':avatarPath
  })
  .eq('id',user.id);
}
Future <String?> uploadAvatar(File image) async {
  final user = supabase.auth.currentUser;
  if (user == null){
    throw Exception("no user found");}
  final path = '${user.id}/avatar.jpg';
  await supabase.storage.from('avatar-custom').upload(
    path,
    image,
    fileOptions: const FileOptions(upsert: true)
  );
  
  return path;
}
}
