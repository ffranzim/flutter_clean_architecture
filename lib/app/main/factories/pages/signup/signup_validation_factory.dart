import 'package:clean_architecture/app/main/builders/builders.dart';

import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../composites/composites.dart';

Validation makeSignUpValidation() {
  return ValidationComposite(validations: makeSignUpValidations());
}

List<FieldValidation> makeSignUpValidations() {
  // ! Triple dot ou Spread Operator concatena listas
  return [
    ... ValidationBuilder.field('email').required().email().build(),
    ... ValidationBuilder.field('name').required().min(minSize: 3).build(),
    ... ValidationBuilder.field('password').required().min(minSize: 3).build(),
    ... ValidationBuilder.field('passwordConfirmation').required().min(minSize: 3).sameAs(fieldToCompare: 'password').build(),
  ];
}
