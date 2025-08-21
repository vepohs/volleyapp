import 'package:volleyapp/core/constants/firestore_fields.dart';
import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/club/data/models/club_model.dart';

class ClubJsonMapper implements BaseMapper<Map<String, dynamic>, ClubModel> {
  @override
  ClubModel from(Map<String, dynamic> input) {
    return ClubModel(
      id: input[FirestoreClubFields.id] as String,
      name: input[FirestoreClubFields.name] as String,
      avatarUrl: input[FirestoreClubFields.avatarUrl] as String,
    );
  }

  @override
  Map<String, dynamic> to(ClubModel output) {
    return {
      FirestoreClubFields.id: output.id,
      FirestoreClubFields.name: output.name,
      FirestoreClubFields.avatarUrl: output.avatarUrl,
    };
  }
}
