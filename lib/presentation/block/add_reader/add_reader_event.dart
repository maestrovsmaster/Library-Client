abstract class AddReaderEvent {}

class SubmitReaderEvent extends AddReaderEvent {
  final String email;
  final String name;
  final String phoneNumber;
  final String phoneNumberAlt;

  SubmitReaderEvent({
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.phoneNumberAlt,
  });
}
