import 'package:volleyapp/core/form/states/form_status_state.dart';

abstract class EmailState extends FormStatusState {
  String get email;
  String? get emailError;
}
