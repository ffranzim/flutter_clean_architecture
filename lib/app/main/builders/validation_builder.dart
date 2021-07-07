import '../../validation/protocols/protocols.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  static ValidationBuilder _instance;
  String fieldName;
  List<FieldValidation> validations = [];

  //! Construtor privado
  ValidationBuilder._();

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._();
    _instance.fieldName = fieldName;
    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(field: fieldName));
    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidation(field: fieldName));
    return this;
  }

  List<FieldValidation> build() => validations;

}
