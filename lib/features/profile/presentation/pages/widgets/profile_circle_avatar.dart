import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app_withai/core/theme/app_pallet.dart';
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
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
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
    final fileExt = image.path
        .split('.')
        .last;
    final filePath = 'avatars/${user.id}.$fileExt';
    final bytes = await image.readAsBytes();
    // رفع الصورة إلى Supabase Storage (bucket: avatar)
    await Supabase.instance.client.storage
        .from('avatars')
        .uploadBinary(
        filePath, bytes, fileOptions: const FileOptions(upsert: true));
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

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Avatar with tap to view full image
        GestureDetector(
          onTap: () {
            if (_image != null ||
                (_avatarUrl != null && _avatarUrl!.isNotEmpty)) {
              showDialog(
                context: context,
                builder: (_) =>
                    Dialog(
                      backgroundColor: Colors.transparent,
                      child: InteractiveViewer(
                        child: _image != null
                            ? Image.file(_image!)
                            : Image.network(_avatarUrl!),
                      ),
                    ),
              );
            }
          },
          child: _loading
              ? const CircleAvatar(
            radius: 50,
            child: CircularProgressIndicator(),
          )
              : CircleAvatar(
            radius: 50,
            backgroundImage: _image != null
                ? FileImage(_image!)
                : (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                ? NetworkImage(_avatarUrl!) as ImageProvider
                : const AssetImage('assets/icons/profile.png'),
          ),
        ),

        // Positioned edit icon
        Positioned(
          bottom: 0,
          right: 4,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding:  EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPallet.mainColor,
              ),
              child: const Icon(
                Icons.edit,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}