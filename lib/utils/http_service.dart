import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shoping_cart/utils/api_exception.dart';
import 'package:shoping_cart/utils/prefs/preference_manager.dart';

class HttpService {
  final Dio _dio;
  final prefsManager = GetIt.instance<PreferencesManager>();

  HttpService({required String baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    // Set up LogInterceptor for logging requests, responses, and errors
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      logPrint: (obj) {
        print(obj); // Custom logging mechanism
      },
    ));

    // Adding the custom AuthInterceptor for authentication
    // _dio.interceptors.add(AuthInterceptor(prefsManager));

    // Adding the TokenRefreshInterceptor for handling token refresh
    // _dio.interceptors.add(TokenRefreshInterceptor(_dio, prefsManager));
    // _dio.interceptors.add(ChuckerDioInterceptor());
  }

  // Helper function for structured error handling
  dynamic _handleError(DioException e) {
    String errorMessage = 'Unknown error occurred';
    print("Exception:_handleError" + e.toString());
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
        break;
      case DioExceptionType.badResponse:
        errorMessage =
            'Received invalid response: ${e.response?.statusMessage}';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request was cancelled';
        break;
      case DioExceptionType.unknown:
        errorMessage = 'Network or other error: ${e.error}';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'Network or other error: ${e.error}';
        break;

      case DioExceptionType.connectionError:
        errorMessage = 'connectionError: ${e.error}';
        break;

      // TODO: Handle this case.
    }

    // Log the error details
    print('DioError: $errorMessage');
    return errorMessage;
  }

  // Generic request method that handles all types of HTTP methods

  Future<Response?> _request(String method, String path,
      {dynamic data, Map<String, dynamic>? queryParams}) async {
    try {
      Response res;
      switch (method.toUpperCase()) {
        case 'GET':
          res = await _dio.get(path, queryParameters: queryParams);
          break;
        case 'POST':
          res = await _dio.post(path, data: data, queryParameters: queryParams);
          break;
        case 'PUT':
          res = await _dio.put(path, data: data, queryParameters: queryParams);
          break;
        case 'DELETE':
          res =
              await _dio.delete(path, data: data, queryParameters: queryParams);
          break;
        case 'PATCH':
          res =
              await _dio.patch(path, data: data, queryParameters: queryParams);
          break;
        default:
          throw UnsupportedError('HTTP method $method not supported');
      }
      // Validate the response and throw if necessary
      return _validateResponse(res);
    } catch (e) {
      // Check if the exception is a DioException
      if (e is DioException) {
        // Ensure response is not null before accessing data
        if (e.response?.data != null) {
          final errorData = e.response?.data;

          // Check if the response data is a JSON map
          if (errorData is Map<String, dynamic>) {
            final status =
                e.response?.statusCode ?? 500; // Default status code if null
            final message = errorData['message'] ?? "Unknown error occurred";

            // Throw a custom ApiException with extracted message and status code
            final exception = ApiException(
              message,
              statusCode: status,
            );

            print("Exception:ApiException" + exception.toString());

            throw exception;
          } else {
            // Handle non-JSON responses
            throw ApiException(
              "Unexpected error format received from server",
              statusCode: e.response?.statusCode ?? 500,
            );
          }
        } else {
          // Handle cases where response or response data is null
          throw ApiException(
            e.message ?? "No response received",
            statusCode: e.response?.statusCode ?? 500,
          );
        }
      }

      // Handle any other type of exception
      throw ApiException(
        'Request failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  // Private method to validate responses
  Response _validateResponse(Response? response) {
    if (response == null) {
      throw ApiException('No response received');
    }
    if (response.statusCode != 200) {
      throw ApiException(
        'Error: ${response.statusMessage ?? "Unknown error"}',
        statusCode: response.statusCode,
      );
    }
    return response;
  }

  // GET request
  Future<Response?> get(String path,
      {Map<String, dynamic>? queryParams}) async {
    return await _request('GET', path, queryParams: queryParams);
  }

  // POST request
  Future<Response?> post(String path,
      {dynamic data, Map<String, dynamic>? queryParams}) async {
    return await _request('POST', path, data: data, queryParams: queryParams);
  }

  // PUT request
  Future<Response?> put(String path,
      {dynamic data, Map<String, dynamic>? queryParams}) async {
    return await _request('PUT', path, data: data, queryParams: queryParams);
  }

  // DELETE request
  Future<Response?> delete(String path,
      {dynamic data, Map<String, dynamic>? queryParams}) async {
    return await _request('DELETE', path, data: data, queryParams: queryParams);
  }

  // PATCH request
  Future<Response?> patch(String path,
      {dynamic data, Map<String, dynamic>? queryParams}) async {
    return await _request('PATCH', path, data: data, queryParams: queryParams);
  }

  // Upload file using FormData
  Future<Response?> uploadFile(String path, FormData formData) async {
    return await _request('POST', path, data: formData);
  }

  // Download file
  Future<Response?> downloadFile(String urlPath, String savePath) async {
    try {
      Response res = await _dio.download(urlPath, savePath);
      return res;
    } catch (e) {
      print('File Download Error: $e');
      return null;
    }
  }
}
