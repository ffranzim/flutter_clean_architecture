import 'package:clean_architecture/app/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = const EmailValidation(field: 'any_field');
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
