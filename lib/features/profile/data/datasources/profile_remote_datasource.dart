import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> fetchProfile(String userId);
  Future<void> updateProfile(ProfileModel profile);
  Future<String> uploadAvatar(String userId, String filePath);
}
