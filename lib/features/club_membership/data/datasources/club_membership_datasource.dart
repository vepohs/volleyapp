import 'package:volleyapp/features/club_membership/data/models/club_membership_model.dart';

abstract class ClubMembershipDataSource {
  Future<ClubMembershipModel> addClubMembership({
    required String clubId,
    required String userId,
    required String roleId,
  });
}
