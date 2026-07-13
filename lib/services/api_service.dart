import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/user_profile.dart';

/// A specific exception type so screens can show a helpful, human message
/// instead of a raw error string.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _timeout = Duration(seconds: 10);

  static Future<List<Post>> getPosts() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        return decoded.map((json) => Post.fromJson(json)).toList();
      } else {
        throw ApiException(
            'Server returned an error (${response.statusCode}). Please try again.');
      }
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on http.ClientException {
      throw ApiException('Could not reach the server. Please try again.');
    } on FormatException {
      throw ApiException('Received an unexpected response from the server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Something went wrong while loading posts.');
    }
  }

  static Future<UserProfile> getUserProfile(int userId) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/users/$userId'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return UserProfile.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw ApiException('User not found.');
      } else {
        throw ApiException(
            'Server returned an error (${response.statusCode}). Please try again.');
      }
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on http.ClientException {
      throw ApiException('Could not reach the server. Please try again.');
    } on FormatException {
      throw ApiException('Received an unexpected response from the server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Something went wrong while loading the profile.');
    }
  }
}