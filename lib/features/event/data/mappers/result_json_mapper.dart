import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/features/event/domain/entities/result.dart';
import 'package:volleyapp/features/event/domain/entities/set_score.dart';

class ResultJsonMapper {
  Map<String, dynamic> to(Result r) => {
    'updatedAt': r.updatedAt.toIso8601String(),
    'sets': r.sets
        .map((s) => {
      'number': s.number,
      'homePoints': s.homePoints,
      'awayPoints': s.awayPoints,
    })
        .toList(),
  };

  Result? from(Map<String, dynamic>? map) {
    if (map == null) return null;

    final setsRaw = (map['sets'] as List<dynamic>? ?? []);
    final sets = setsRaw.map((e) {
      final m = (e as Map).cast<String, dynamic>();
      return SetScore(
        number: m['number'] as int,
        homePoints: m['homePoints'] as int,
        awayPoints: m['awayPoints'] as int,
      );
    }).toList();

    final ts = map['updatedAt'];
    final updatedAt = ts is Timestamp
        ? ts.toDate()
        : (ts is String ? DateTime.parse(ts) : DateTime.now());

    return Result(
      sets: sets,
      updatedAt: updatedAt,
    );
  }
}
