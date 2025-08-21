import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/club_membership/data/models/club_membership_model.dart';
import 'package:volleyapp/features/club_membership/domain/entities/club_membership.dart';
import 'package:volleyapp/features/club_membership/domain/entities/role.dart';

class ClubMembershipMapper
    implements BaseMapper<ClubMembershipModel, ClubMembership> {
  @override
  ClubMembership from(ClubMembershipModel input) {
    return ClubMembership(
      id: input.id,
      clubId: input.clubId,
      userId: input.userId,
      role: Role.fromId(input.roleId),
      joinedAt: input.joinedAt,
    );
  }

  @override
  ClubMembershipModel to(ClubMembership output) {
    return ClubMembershipModel(
      id: output.id,
      clubId: output.clubId,
      userId: output.userId,
      roleId: output.role.id,
      joinedAt: output.joinedAt,
    );
  }
}
