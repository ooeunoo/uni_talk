enum AuthProvider {
  local,
  google,
  kakao,
  apple,
}

String getAuthProvider(AuthProvider provider) {
  switch (provider) {
    case AuthProvider.google:
      return 'google';
    case AuthProvider.kakao:
      return 'kakao';
    case AuthProvider.apple:
      return 'apple';
    default:
      return 'unknown';
  }
}
