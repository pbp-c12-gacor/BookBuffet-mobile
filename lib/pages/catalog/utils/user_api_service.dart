import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;

class UserApiService {
  static String baseUrl = 'https://bookbuffet.onrender.com/api/auth';

  static bool isLoggedin(CookieRequest cookieRequest) {
    return cookieRequest.loggedIn;
  }

  static Future<bool> addToMyBooks(
      CookieRequest cookieRequest, int bookId) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/addtomybooks'));
    request.headers.addAll(cookieRequest.headers);
    request.fields['book_id'] = bookId.toString();

    final response = await http.Response.fromStream(await request.send());
    return jsonDecode(response.body)['status'];
  }

  static Future<bool> removeFromMyBooks(
      CookieRequest cookieRequest, int bookId) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/removemybooks'));
    request.headers.addAll(cookieRequest.headers);
    request.fields['book_id'] = bookId.toString();

    final response = await http.Response.fromStream(await request.send());
    return jsonDecode(response.body)['status'];
  }

  static Future<bool> isBookInMyBooks(
      CookieRequest cookieRequest, int bookId) async {
    final request =
        http.Request('GET', Uri.parse('$baseUrl/isinmybooks/$bookId'));
    request.headers.addAll(cookieRequest.headers);

    final response = await http.Response.fromStream(await request.send());
    return jsonDecode(response.body)['status'];
  }
}
