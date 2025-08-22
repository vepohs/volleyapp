class AddEventException implements Exception {
  final String message;
  const AddEventException(this.message);
  @override
  String toString() => message;
}

class GetEventByIdException implements Exception {
  final String message;
  const GetEventByIdException(this.message);
  @override
  String toString() => message;
}

class UpdateMatchResultException implements Exception {
  final String message;
  const UpdateMatchResultException(this.message);
  @override
  String toString() => message;
}

class CancelEventException implements Exception {
  final String message;
  const CancelEventException(this.message);
  @override
  String toString() => message;
}
