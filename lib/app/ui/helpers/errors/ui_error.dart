import 'package:clean_architecture/app/ui/helpers/helpers.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField: return R.strings.msgRequiredField;
      case UIError.invalidField: return R.strings.msgInvalidFields;
      case UIError.invalidCredentials: return R.strings.msgInvalidCredentials;
      case UIError.unexpected: return R.strings.msgUnexpected;
      default: return R.strings.msgUnexpected;
    }
  }
}