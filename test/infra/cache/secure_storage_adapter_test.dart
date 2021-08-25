import 'package:clean_architecture/app/infra/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  FlutterSecureStorageSpy secureStorage;
  SecureStorageAdapter sut;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('saveSecure', () {
    void mockSaveSecureError() => when(
            secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());

    test('Should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throws', () async {
      mockSaveSecureError();
      final future = sut.saveSecure(key: key, value: value);

      // ! TypeMatcher verifica se é do mesmo tipo - Tipo um instaceOf
      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    PostExpectation mockFecthSecureCall() =>
        when(secureStorage.read(key: anyNamed('key')));

    void mockFecthSecure() =>
        mockFecthSecureCall().thenAnswer((_) async => value);

    void mockFecthSecureError() => mockFecthSecureCall().thenThrow(Exception());

    setUp(() {
      mockFecthSecure();
    });

    test('Should call fetch secure with correct value', () async {
      await sut.fetchSecure(key: key);

      verify(secureStorage.read(key: key));
    });

    test('Should correct value on success', () async {
      final fetchedValue = await sut.fetchSecure(key: key);

      expect(fetchedValue, value);
    });

    test('Should throw if fetchSecure throws ', () async {

      mockFecthSecureError();

      final future = sut.fetchSecure(key: key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}
