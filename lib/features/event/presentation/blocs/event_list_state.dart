
import 'package:volleyapp/features/event/domain/entities/event.dart';

abstract class EventListState  {
  const EventListState();
}

class EventListInitial extends EventListState {
  const EventListInitial();
}

class EventListLoading extends EventListState {
  const EventListLoading();
}

class EventListLoaded extends EventListState {
  final List<Event> events;
  const EventListLoaded(this.events);

}

class EventListFailure extends EventListState {
  final String message;
  const EventListFailure(this.message);

}
