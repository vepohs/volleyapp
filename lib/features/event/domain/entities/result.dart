import 'package:volleyapp/features/event/domain/entities/set_score.dart';

class Result {
  final List<SetScore> sets;
  final DateTime updatedAt;

  Result({
    required this.sets,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  int get homeSets => sets.where((s) => s.homeWon).length;
  int get awaySets => sets.where((s) => s.awayWon).length;

  bool get homeWon => homeSets > awaySets;
  bool get awayWon => awaySets > homeSets;

  @override
  String toString() =>
      "Result: $homeSets-$awaySets (updatedAt: $updatedAt)";
}
