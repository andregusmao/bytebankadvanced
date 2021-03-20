import 'package:bytebankadvanced/http/interceptors/logging_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';

const String BASE_URL = 'http://192.168.15.150:8080';

final Client client = HttpClientWithInterceptor.build(
  interceptors: [LoggingInterceptor()],
);

