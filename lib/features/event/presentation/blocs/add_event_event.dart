import 'package:volleyapp/features/event/domain/use_cases/add_event/add_event_params.dart';

abstract class AddEventEvent  {
  const AddEventEvent();
}

class AddEventSubmitted extends AddEventEvent {
  final AddEventParams params;
  const AddEventSubmitted(this.params);
}
