class HttpException implements Exception {
  final String msg;
  final int statusCode;

  HttpException({
    required this.msg, 
    required this.statusCode
  });

  String toString() {
    return msg;
  }
}