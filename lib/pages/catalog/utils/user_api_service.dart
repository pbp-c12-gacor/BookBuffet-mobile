import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;

class UserApiService {
  static String baseUrl = 'https://bookbuffet.onrender.com/api/auth';

  static bool isLoggedin(CookieRequest cookieRequest) {
    return cookieRequest.loggedIn;
  }

  static Future<bool> addToMyBooks(
      CookieRequest cookieRequest, String bookId) async {
    final request =
        http.Request('POST', Uri.parse('$baseUrl/addtomybooks/$bookId'));
    request.headers.addAll(cookieRequest.headers);

    final response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> removeFromMyBooks(
      CookieRequest cookieRequest, String bookId) async {
    final request =
        http.Request('POST', Uri.parse('$baseUrl/removemybooks/$bookId'));
    request.headers.addAll(cookieRequest.headers);

    final response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> isBookInMyBooks(
      CookieRequest cookieRequest, String bookId) async {
    final request =
        http.Request('GET', Uri.parse('$baseUrl/isinmybooks/$bookId'));
    request.headers.addAll(cookieRequest.headers);

    final response = await http.Response.fromStream(await request.send());
    return jsonDecode(response.body)['status'];
  }
}
