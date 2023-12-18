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

  Future<List<Report>> fetchReports() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse('https://bookbuffet.onrender.com/report/json/');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Book Buffet',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF35155D))),
          backgroundColor: const Color(0xFF4477CE)),
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
                                  color: Color(0xFF35155D), fontSize: 20),
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
                                Navigator.push(
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
                                    color: Color(0xFF8CABFF),
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
