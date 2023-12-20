import 'dart:convert';
import 'package:bookbuffet/pages/base.dart';
import 'package:bookbuffet/pages/report/models/report.dart';
import 'package:bookbuffet/pages/report/screens/detail_report.dart';
import 'package:http/http.dart' as http;
import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/home/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ShowReportsPage extends StatefulWidget {
  const ShowReportsPage({super.key});

  @override
  State<ShowReportsPage> createState() => _ShowReportsPageState();
}

class _ShowReportsPageState extends State<ShowReportsPage> {
  static String baseApiUrl = 'https://bookbuffet.onrender.com';

  Future<List<Report>> fetchReports() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse('$baseApiUrl/report/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Report> list_reports = [];
    for (var d in data) {
      if (d != null) {
        list_reports.add(Report.fromJson(d));
      }
    }
    return list_reports;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Book Buffet',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFFF1F1F0))),
          backgroundColor: const Color(0xFFC5A992)),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                  future: fetchReports(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (!snapshot.hasData) {
                        return const Column(
                          children: [
                            Text(
                              "Tidak ada data Report.",
                              style: TextStyle(
                                  color: Color(0xFFF1F1F0), fontSize: 20),
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      } else {
                        return Expanded(
                          // Add this
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailReportPage(
                                        report: snapshot.data![index]),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFC5A992),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data![index].fields.bookTitle}",
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        "${snapshot.data![index].fields.comment}")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ); // Add this
                      }
                    }
                  })
            ],
          ),
        );
  }
}
