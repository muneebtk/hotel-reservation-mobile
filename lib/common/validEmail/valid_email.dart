bool isValidEmail(String email) {
  final emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegExp.hasMatch(email);
}

bool isPhoneNumberValid(String phoneNumber) {
  const pattern = r'^[0-9]{10}$';
  final regExp = RegExp(pattern);
  return regExp.hasMatch(phoneNumber);
}

bool isEmailValid(String email) {
  const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final regExp = RegExp(pattern);
  return regExp.hasMatch(email);
}
