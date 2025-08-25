import 'package:volleyapp/features/club_join_request/data/models/club_join_request_model.dart';

abstract class ClubRequestDataSource {
  Future<ClubJoinRequestModel> submit({
    required String clubId,
    required String userId,
  });

  Future<ClubJoinRequestModel> approve({required String requestId});

  Future<ClubJoinRequestModel> reject({required String requestId});

  Future<ClubJoinRequestModel> cancel({required String requestId});

  Future<List<ClubJoinRequestModel>> getAllClubJoinRequestByClubId({required String clubId});
}

