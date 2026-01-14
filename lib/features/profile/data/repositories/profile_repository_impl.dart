import 'package:fpdart/fpdart.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    try {
      final profile = await remoteDataSource.fetchProfile(userId);
      return right(profile);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile(ProfileEntity profile) async {
    try {
      await remoteDataSource.updateProfile(profile as dynamic);
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<String> uploadAvatar(String userId, String filePath) {
    return remoteDataSource.uploadAvatar(userId, filePath);
  }
}

