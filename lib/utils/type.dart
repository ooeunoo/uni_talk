bool isValidPhoneNumber(String value) {
  final RegExp phoneRegex =
      RegExp(r'^\+?(\d{2,3})?-?0?(\d{1,2})-?(\d{3,4})-?(\d{4})$');
  return phoneRegex.hasMatch(value);
}
