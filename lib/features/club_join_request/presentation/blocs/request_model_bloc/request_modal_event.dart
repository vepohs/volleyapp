abstract class RequestsModalEvent {}

class LoadRequestsModal extends RequestsModalEvent {
}

class ApproveRequestPressed extends RequestsModalEvent {
  final String requestId;
  ApproveRequestPressed({required this.requestId});
}