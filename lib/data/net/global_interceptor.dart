import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  String? _idToken;
  String? _postfix;

  void updateToken(String idToken) {
    print("updateToken: $idToken");
    _idToken = idToken;
  }

  void setPostfix(String postfix) {
    print("setPostfix: $postfix");
    _postfix = postfix;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_idToken != null) {
      options.headers['Authorization'] = 'Bearer $_idToken';
    }

    if (_postfix != null) {
      options.queryParameters = Map.from(options.queryParameters)
        ..['postfix'] = _postfix;
    }

    super.onRequest(options, handler);
  }
}
