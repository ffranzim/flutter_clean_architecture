import 'package:clean_architecture/app/validation/protocols/protocols.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class EmailValidation implements FieldValidation {
  @override
  final String field;

  EmailValidation(this.field);

  @override
  String validate({@required String value}) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return isValid ? null : 'Campo inválido.';
  }
}

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null if email is empty', () {
    final error = sut.validate(value: '');

    expect(error, null);
  });

  test('Should return null if email is null', () {
    final error = sut.validate(value: null);

    expect(error, null);
  });

  test('Should return null if email is valid', () {
    final error = sut.validate(value: 'fernando.franzim@gmail.com');

    expect(error, null);
  });

  test('Should return null if email is invalid', () {
    final error = sut.validate(value: 'fernando.franzim');

    expect(error, 'Campo inválido.');
  });
}
