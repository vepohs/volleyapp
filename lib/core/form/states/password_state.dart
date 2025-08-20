import 'package:volleyapp/core/form/states/form_status_state.dart';

abstract class PasswordState extends FormStatusState{
  String get password;
  String? get passwordError;
}