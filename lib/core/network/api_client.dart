import 'package:dio/dio.dart';

class ApiClient {
  final String baseUrl = 'https://hp-api.onrender.com/api';
  final Dio _dio;

  ApiClient() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            try {
              return handler.resolve(await _retry(error.requestOptions));
            } catch (e) {
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<List<dynamic>> getAllCharacters() async {
    try {
      final response = await _dio.get('/characters');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Karakterler alınırken bir ağ hatası oluştu: ${e.message}');
    } catch (e) {
      throw Exception('Karakterler alınırken beklenmeyen bir hata oluştu: $e');
    }
  }

  Future<List<dynamic>> getCharacterById(String id) async {
    try {
      final response = await _dio.get('/character/$id');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Karakter detayları alınırken bir ağ hatası oluştu: ${e.message}');
    } catch (e) {
      throw Exception('Karakter detayları alınırken beklenmeyen bir hata oluştu: $e');
    }
  }

  Future<List<dynamic>> getHogwartsStudents() async {
    try {
      final response = await _dio.get('/characters/students');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Öğrenciler alınırken bir ağ hatası oluştu: ${e.message}');
    } catch (e) {
      throw Exception('Öğrenciler alınırken beklenmeyen bir hata oluştu: $e');
    }
  }

  Future<List<dynamic>> getHogwartsStaff() async {
    try {
      final response = await _dio.get('/characters/staff');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Personel alınırken bir ağ hatası oluştu: ${e.message}');
    } catch (e) {
      throw Exception('Personel alınırken beklenmeyen bir hata oluştu: $e');
    }
  }

  Future<List<dynamic>> getCharactersByHouse(String house) async {
    try {
      final response = await _dio.get('/characters/house/$house');
      return response.data;
    } on DioException catch (e) {
      throw Exception('$house üyeleri alınırken bir ağ hatası oluştu: ${e.message}');
    } catch (e) {
      throw Exception('$house üyeleri alınırken beklenmeyen bir hata oluştu: $e');
    }
  }

  Future<List<dynamic>> getAllSpells() async {
    try {
      final response = await _dio.get('/spells');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Büyüler alınırken bir ağ hatası oluştu: ${e.message}');
    } catch (e) {
      throw Exception('Büyüler alınırken beklenmeyen bir hata oluştu: $e');
    }
  }
} 