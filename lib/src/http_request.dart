class HttpRequest {
  final String url;
  final Map<String, String> headers;
  final String method;

  HttpRequest({
    required this.url,
    required this.headers,
    required this.method,
  });
}
