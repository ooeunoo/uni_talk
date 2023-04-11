import 'package:uni_talk/config/auth_provider.dart';

class User {
  final String id;
  final String email;
  final String displayName;
  final String phoneNumber;
  final AuthProvider provider;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.phoneNumber,
    required this.provider,
  });
}
