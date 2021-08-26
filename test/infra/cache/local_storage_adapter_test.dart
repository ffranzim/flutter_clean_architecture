import 'package:clean_architecture/app/infra/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  LocalStorageAdapter sut;
  LocalStorage localStorage;
  String key;
  dynamic value;

  void mockDeleteError() => when(localStorage.deleteItem(any)).thenThrow(Exception());
  void mockSaveError() => when(localStorage.setItem(any, any)).thenThrow(Exception());

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
  });

  group(('save'), () {
    test('Should call localStorage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(localStorage.deleteItem(key)).called(1);
      verify(localStorage.setItem(key, value)).called(1);
    });

    test('Should throw if deleteItem throws', () async {
      mockDeleteError();
      final future = sut.save(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });

    test('Should throw if setItem throws', () async {
      mockSaveError();
      final future = sut.save(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group(('delete'), () {
    test('Should call localStorage with correct values', () async {
      await sut.delete(key: key);

      verify(localStorage.deleteItem(key)).called(1);
     });

    // test('Should throw if deleteItem throws', () async {
    //   mockDeleteError();
    //   final future = sut.save(key: key, value: value);
    //
    //   expect(future, throwsA(const TypeMatcher<Exception>()));
    // });
    //
    // test('Should throw if setItem throws', () async {
    //   mockSaveError();
    //   final future = sut.save(key: key, value: value);
    //
    //   expect(future, throwsA(const TypeMatcher<Exception>()));
    // });
  });
}
