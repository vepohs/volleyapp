import 'package:volleyapp/features/club_membership/domain/entities/role.dart';

class AddClubMembershipParams  {
  final String clubId;
  final String userId;
  final Role role;

  const AddClubMembershipParams({
    required this.clubId,
    required this.userId,
    required this.role,
  });

}
