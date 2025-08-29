import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileCircleAvatar extends StatefulWidget {
  const ProfileCircleAvatar({
    super.key,
  });

  @override
  State<ProfileCircleAvatar> createState() => _ProfileCircleAvatarState();
}

class _ProfileCircleAvatarState extends State<ProfileCircleAvatar> {
  File? _image;
  String? _avatarUrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchAvatarUrl();
  }

  Future<void> _fetchAvatarUrl() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final response = await Supabase.instance.client
        .from('profiles')
        .select('avatar_url')
        .eq('id', user.id)
        .single();
    setState(() {
      _avatarUrl = response['avatar_url'];
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _loading = true;
      });
      await _uploadImage(_image!);
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _uploadImage(File image) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final fileExt = image.path.split('.').last;
    final filePath = 'avatars/${user.id}.$fileExt';
    final bytes = await image.readAsBytes();
    // رفع الصورة إلى Supabase Storage (bucket: avatar)
    await Supabase.instance.client.storage
        .from('avatars')
        .uploadBinary(filePath, bytes, fileOptions: const FileOptions(upsert: true));
    // الحصول على رابط الصورة
    final publicUrl = Supabase.instance.client.storage
        .from('avatars')
        .getPublicUrl(filePath);
    // تحديث رابط الصورة في قاعدة البيانات
    await Supabase.instance.client
        .from('profiles')
        .update({'avatar_url': publicUrl})
        .eq('id', user.id);
    setState(() {
      _avatarUrl = publicUrl;
    });
    // تحديث Drawer تلقائياً (لو محتاج تعمل refresh)
    // يمكنك استخدام Provider أو أي state management لإعادة بناء الـ Drawer
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: _loading
          ? const CircleAvatar(radius: 50, child: CircularProgressIndicator())
          : CircleAvatar(
              radius: 50,
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                      ? NetworkImage(_avatarUrl!) as ImageProvider
                      : const AssetImage('assets/icons/profile.png'),
            ),
    );
  }
}


