import 'package:curso_avancado/presentation/presenters/presenters.dart';
import 'package:curso_avancado/presentation/protocols/protocols.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late StreamLoginController sut;
  late Validation validation;
  late String email;

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginController(validation: validation);
    email = faker.internet.email();
  });
  test('should call Validation with correct email', () async {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });
  test('should call Validation with correct email', () async {
    when(
      () => validation.validate(
          field: any(named: 'field'), value: any(named: 'value')),
    ).thenReturn('error');

    sut.emailErrorStream
        .listen((expectAsync1((error) => expect(error, 'error'))));

    // expectLater(sut.emailErrorStream, emits('error'));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });
}
