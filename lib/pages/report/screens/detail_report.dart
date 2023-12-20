import 'dart:convert';
import 'package:bookbuffet/pages/report/screens/show_reports.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookbuffet/pages/report/models/report.dart';
import 'package:http/http.dart' as http;

class DetailReportPage extends StatelessWidget {
  final Report report;

  const DetailReportPage({Key? key, required this.report}) : super(key: key);

  static String baseApiUrl = 'https://bookbuffet.onrender.com';

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    Future<bool> getUserIsStaff() async {
      final request = context.watch<CookieRequest>();

      var response = await request.get('$baseApiUrl/publish/is-staff/');

      if (response != null) {
        bool isStaff = response['is_staff'];

        return isStaff;
      } else {
        throw Exception('Failed to load user is staff status');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Report Detail",
        ),
        backgroundColor: const Color(0xFFC5A992),
        foregroundColor: const Color(0xFFF1F1F0),
      ),
      body: FutureBuilder(
        future: getUserIsStaff(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator while waiting
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Show error message if there's an error
          } else if (snapshot.data == true) {
            // Check if user is staff
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${report.fields.bookTitle}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text("Comment    : ${report.fields.comment}"),
                  ElevatedButton(
                    child: const Text('Delete Report'),
                    onPressed: () async {
                      int id = report.pk;
                      final response = await request.postJson(
                        '$baseApiUrl/report/delete-report-flutter/$id/',
                        jsonEncode({
                          "id": report.pk,
                        }),
                      );
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Report has been deleted!"),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowReportsPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("There is an error, please try again."),
                        ));
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${report.fields.bookTitle}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                        selectionColor: Color(0xFFC5A992),
                  ),
                  const SizedBox(height: 10),
                  Text("Comment    : ${report.fields.comment}"),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
