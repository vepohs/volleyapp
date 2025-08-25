abstract class RequestsModalEvent {}

class LoadRequestsModal extends RequestsModalEvent {
}

class TeamSelectionChanged extends RequestsModalEvent {
  final String requestId;
  final String? teamId;
  TeamSelectionChanged({required this.requestId, required this.teamId});
}

class RoleSelectionChanged extends RequestsModalEvent {
  final String requestId;
  final String? roleId;
  RoleSelectionChanged({required this.requestId, required this.roleId});
}

class ApproveRequestPressed extends RequestsModalEvent {
  final String requestId;
  ApproveRequestPressed({required this.requestId});
}

class RejectRequestPressed extends RequestsModalEvent {
  final String requestId;
  RejectRequestPressed({required this.requestId});
}