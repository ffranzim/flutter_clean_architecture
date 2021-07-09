import 'package:clean_architecture/app/infra/cache/local_storage_adapter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

FlutterSecureStorageSpy secureStorage;
LocalStorageAdapater sut;
String key;
String value;

void main() {
  void mockSaveSecureError() =>
      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenThrow(Exception());

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapater(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  test('Should call save secure with correct values', () async {
    await sut.saveSecure(key: key, value: value);

    verify(secureStorage.write(key: key, value: value));
  });

  test('Should thow if save secure throw', () async {
    mockSaveSecureError();
    final future = sut.saveSecure(key: key, value: value);

    // ! TypeMatcher verifica se a classe é do mesmo tipo
    expect(future, throwsA(const TypeMatcher<Exception>()));
  });
}
