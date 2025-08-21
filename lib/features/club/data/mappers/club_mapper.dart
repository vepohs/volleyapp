import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/club/data/models/club_model.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';

class ClubMapper implements BaseMapper<ClubModel, Club> {
  @override
  Club from(ClubModel input) {
    return Club(
      id: input.id,
      name: input.name,
      avatarUrl: input.avatarUrl,
    );
  }

  @override
  ClubModel to(Club output) {
    return ClubModel(
      id: output.id,
      name: output.name,
      avatarUrl: output.avatarUrl,
    );
  }
}
