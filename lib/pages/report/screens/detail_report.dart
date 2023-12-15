import 'package:flutter/material.dart';
import 'package:bookbuffet/pages/report/models/report.dart';

class DetailReportPage extends StatelessWidget {
  final Report report;

  const DetailReportPage({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Report Detail",
        ),
        backgroundColor: const Color(0xFFC5A992),
        foregroundColor: const Color(0xFFF1F1F0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${report.fields.bookTitle}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Comment    : ${report.fields.comment}")
          ],
        ),
      ),
    );
  }
}
