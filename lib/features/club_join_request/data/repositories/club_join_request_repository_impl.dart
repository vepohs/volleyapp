import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';
import 'package:volleyapp/features/club_join_request/data/datasources/club_join_request_datasource.dart';
import 'package:volleyapp/features/club_join_request/data/mappers/club_join_request_mapper.dart';
import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';
import 'package:volleyapp/features/club_join_request/domain/repositories/club_join_request_repository.dart';
import 'package:volleyapp/features/user/domain/repositories/user_repository.dart';

class ClubRequestRepositoryImpl implements ClubJoinRequestRepository {
  final ClubRequestDataSource _datasource;
  final ClubJoinRequestMapper _mapper = ClubJoinRequestMapper();
  final UserRepository _userRepository;

  ClubRequestRepositoryImpl(this._datasource, this._userRepository);

  @override
  Future<Either<Failure, ClubJoinRequest>> submit({
    required String clubId,
    required String userId,
  }) async {
    try {
      final model = await _datasource.submit(clubId: clubId, userId: userId);
      final userRes = await _userRepository.getUserById(id: model.userId);
      return userRes.fold(
            (f) => Left(f),
            (maybeUser) => maybeUser.fold(
              () => Left(Failure('User not found for join request')),
              (user) => Right(_mapper.from(model, user: user)),
        ),
      );
    } catch (e) {
      return Left(Failure('Submit join request failed: $e'));
    }
  }

  @override
  Future<Either<Failure, ClubJoinRequest>> approve({
    required String requestId,
  }) async {
    try {
      final model = await _datasource.approve(requestId: requestId);

      final userRes = await _userRepository.getUserById(id: model.userId);
      return userRes.fold(
            (f) => Left(f),
            (maybeUser) => maybeUser.fold(
              () => Left(Failure('User not found for join request')),
              (user) => Right(_mapper.from(model, user: user)),
        ),
      );
    } catch (e) {
      return Left(Failure('Approve join request failed: $e'));
    }
  }

  @override
  Future<Either<Failure, ClubJoinRequest>> reject({
    required String requestId,
  }) async {
    try {
      final model = await _datasource.reject(requestId: requestId);

      final userRes = await _userRepository.getUserById(id: model.userId);
      return userRes.fold(
            (f) => Left(f),
            (maybeUser) => maybeUser.fold(
              () => Left(Failure('User not found for join request')),
              (user) => Right(_mapper.from(model, user: user)),
        ),
      );
    } catch (e) {
      return Left(Failure('Reject join request failed: $e'));
    }
  }

  @override
  Future<Either<Failure, ClubJoinRequest>> cancel({
    required String requestId,
  }) async {
    try {
      final model = await _datasource.cancel(requestId: requestId);

      final userRes = await _userRepository.getUserById(id: model.userId);
      return userRes.fold(
            (f) => Left(f),
            (maybeUser) => maybeUser.fold(
              () => Left(Failure('User not found for join request')),
              (user) => Right(_mapper.from(model, user: user)),
        ),
      );
    } catch (e) {
      return Left(Failure('Cancel join request failed: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ClubJoinRequest>>> getAllClubJoinRequestByClubId({
    required String clubId,
  }) async {
    try {
      final models =
      await _datasource.getAllClubJoinRequestByClubId(clubId: clubId);

      final List<ClubJoinRequest> entities = [];

      for (final m in models) {
        final userRes = await _userRepository.getUserById(id: m.userId);
        final entity = await userRes.fold<ClubJoinRequest?>(
              (f) => null,
              (maybeUser) => maybeUser.fold(
                () => null,
                (user) => _mapper.from(m, user: user),
          ),
        );
        if (entity != null) entities.add(entity);
      }

      return Right(entities);
    } catch (e) {
      return Left(Failure('Get all club join requests failed: $e'));
    }
  }
}
