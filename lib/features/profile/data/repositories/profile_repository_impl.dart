import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileEntity> getProfile(String userId) {
    return remoteDataSource.fetchProfile(userId);
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) {
    return remoteDataSource.updateProfile(profile as dynamic);
  }

  @override
  Future<String> uploadAvatar(String userId, String filePath) {
    return remoteDataSource.uploadAvatar(userId, filePath);
  }
}
