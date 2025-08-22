
abstract class EventException implements Exception {
  final String message;
  const EventException(this.message);

  @override
  String toString() => "$runtimeType: $message";
}

class AddEventException extends EventException {
  const AddEventException(super.message);
}

class GetEventByIdException extends EventException {
  const GetEventByIdException(super.message);
}

class UpdateMatchResultException extends EventException {
  const UpdateMatchResultException(super.message);
}

class CancelEventException extends EventException {
  const CancelEventException(super.message);
}

class GetAllEventsException extends EventException {
  const GetAllEventsException(super.message);
}
