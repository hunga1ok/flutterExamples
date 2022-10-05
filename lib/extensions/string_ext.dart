extension CheckString on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;
  String get orEmpty => this ?? '';
  bool get isUrl {
    var urlPattern =
        r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    var result = RegExp(urlPattern, caseSensitive: false).firstMatch(orEmpty);
    return result != null;
  }
}
