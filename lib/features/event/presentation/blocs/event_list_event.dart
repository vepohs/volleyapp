abstract class EventListEvent  {
  const EventListEvent();
}

class EventListRequested extends EventListEvent {
  const EventListRequested();
}

class EventListRefreshed extends EventListEvent {
  const EventListRefreshed();
}
