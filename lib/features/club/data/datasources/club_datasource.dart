import 'package:volleyapp/features/club/data/models/club_model.dart';

abstract class ClubDataSource {
  Future<ClubModel> addClub({
    required String id,
    required String name,
    String? avatarUrl,
  });
}
