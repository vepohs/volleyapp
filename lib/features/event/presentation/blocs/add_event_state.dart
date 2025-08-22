import 'package:volleyapp/features/event/domain/entities/event.dart';

abstract class AddEventState {
  const AddEventState();
}

class AddEventIdle extends AddEventState {
  const AddEventIdle();
}

class AddEventSubmitting extends AddEventState {
  const AddEventSubmitting();
}

class AddEventSuccess extends AddEventState {
  final Event created;
  const AddEventSuccess(this.created);
}

class AddEventFailure extends AddEventState {
  final String message;
  const AddEventFailure(this.message);
}
