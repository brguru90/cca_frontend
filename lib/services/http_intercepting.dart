import 'package:cca_vijayapura/services/temp_store.dart';
import 'package:http/http.dart' as http;

class MyHttpInterceptor extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // intercept each call and add the Authorization header if token is available
    request.headers.putIfAbsent('Authorization', () => "1234");
    shared_logger.d(request.headers);

    return request.send();
  }
}
