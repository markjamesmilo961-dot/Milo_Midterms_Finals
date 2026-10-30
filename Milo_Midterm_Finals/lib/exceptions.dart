class ClinicException implements Exception {
  final String message;
  ClinicException(this.message);

  @override
  String toString() => 'ClinicException: $message';
}
