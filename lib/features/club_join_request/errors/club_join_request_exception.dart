abstract class ClubRequestException implements Exception {
  final String message;

  const ClubRequestException(this.message);

  @override
  String toString() => "$runtimeType: $message";
}

class SubmitClubJoinRequestException extends ClubRequestException {
  const SubmitClubJoinRequestException(super.message);
}

class ApproveClubJoinRequestException extends ClubRequestException {
  const ApproveClubJoinRequestException(super.message);
}

class RejectClubJoinRequestException extends ClubRequestException {
  const RejectClubJoinRequestException(super.message);
}

class CancelClubJoinRequestException extends ClubRequestException {
  const CancelClubJoinRequestException(super.message);
}

class DuplicatePendingRequestException extends ClubRequestException {
  const DuplicatePendingRequestException(super.message);
}

class GetAllClubJoinRequestException extends ClubRequestException {
  const GetAllClubJoinRequestException(super.message);
}
