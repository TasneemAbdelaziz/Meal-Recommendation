import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import 'profile_remote_datasource.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<ProfileModel> fetchProfile(String userId) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return ProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch profile: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    try {
      await supabaseClient
          .from('profiles')
          .update(profile.toJson())
          .eq('id', profile.id);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadAvatar(String userId, String filePath) async {
    try {
      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      
      await supabaseClient.storage
          .from('avatars')
          .uploadBinary(fileName, bytes);

      final url = supabaseClient.storage
          .from('avatars')
          .getPublicUrl(fileName);
      
      return url;
    } catch (e) {
      throw Exception('Failed to upload avatar: ${e.toString()}');
    }
  }
}
