import 'package:dio/dio.dart';

class ApiClient {
  final String baseUrl = 'https://hp-api.onrender.com/api';
  final Dio _dio;

  ApiClient() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 5);
  }

  // Tüm karakterleri çeker
  Future<List<dynamic>> getAllCharacters() async {
    try {
      final response = await _dio.get('/characters');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ID'ye göre belirli bir karakter çeker
  Future<List<dynamic>> getCharacterById(String id) async {
    try {
      final response = await _dio.get('/character/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Hogwarts öğrencilerini çeker
  Future<List<dynamic>> getHogwartsStudents() async {
    try {
      final response = await _dio.get('/characters/students');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Hogwarts çalışanlarını çeker
  Future<List<dynamic>> getHogwartsStaff() async {
    try {
      final response = await _dio.get('/characters/staff');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Belirtilen ev mensubu karakterleri çeker
  Future<List<dynamic>> getCharactersByHouse(String house) async {
    try {
      final response = await _dio.get('/characters/house/$house');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Tüm büyüleri çeker
  Future<List<dynamic>> getAllSpells() async {
    try {
      final response = await _dio.get('/spells');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
} 