import 'package:volleyapp/features/event/domain/entities/result.dart';

class UpdateMatchResultParams {
  final String eventId;
  final Result result;

  const UpdateMatchResultParams({
    required this.eventId,
    required this.result,
  });
}
