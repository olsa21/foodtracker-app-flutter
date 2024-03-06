class ServerException implements Exception {}

class ServerTimeoutException implements Exception {}

class NoConnectionException implements Exception {}

class ResultEmptyException implements Exception {}

class EmptySearchException implements Exception {}

class LocalDatabaseException implements Exception {
  final String message;

  LocalDatabaseException({required this.message});
}
