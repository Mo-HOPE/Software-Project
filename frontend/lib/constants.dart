import 'package:form_field_validator/form_field_validator.dart';

const defaultPadding = 16.0;

final nameValidator = MultiValidator([
  RequiredValidator(errorText: 'Your Name is required'),
]);

final emaildValidator = MultiValidator([
  RequiredValidator(errorText: 'an Email is required'),
  EmailValidator(errorText: "Enter a valid email address"),
]);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'a Password is required'),
  MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      errorText: 'passwords must have at least one special character')
]);
