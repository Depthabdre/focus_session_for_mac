class CacheException implements Exception {
  const CacheException(this.message);

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class SystemException implements Exception {
  const SystemException(this.message);

  final String message;

  @override
  String toString() => 'SystemException: $message';
}
