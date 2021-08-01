import 'package:clean_architecture/app/presentation/protocols/protocols.dart';
import 'package:clean_architecture/app/validation/validators/validators.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = const EmailValidation(field: 'email');
  });

  test('Should return null on invalid case', () {
    final error = sut.validate(input: {});

    expect(error, null);
  });

  test('Should return null if email is empty', () {
    final formData = {'email': ''};
    final error = sut.validate(input: formData);

    expect(error, null);
  });

  test('Should return null if email is null', () {
    final formData = {'email': null};
    final error = sut.validate(input: formData);

    expect(error, null);
  });

  test('Should return null if email is valid', () {
    final formData = {'email': faker.internet.email()};
    final error = sut.validate(input: formData);

    expect(error, null);
  });

  test('Should return null if email is invalid', () {
    final formData = {'email': faker.internet.domainName()};

    final error = sut.validate(input: formData);

    expect(error, ValidationError.invalidField);
  });
}
