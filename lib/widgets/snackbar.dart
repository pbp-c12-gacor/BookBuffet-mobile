import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message,
    {Color? textColor, Color? backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      children: [
        Icon(Icons.check_circle,
            color: textColor ?? primaryColor), // Ikon sukses
        SizedBox(width: 16), // Jarak antara ikon dan teks
        Expanded(
          child: Text(
            message,
            style: TextStyle(fontSize: 16, color: textColor ?? primaryColor),
          ),
        ),
      ],
    ),
    backgroundColor:
        backgroundColor ?? secondaryColor, // Warna latar belakang default
    dismissDirection: DismissDirection.horizontal,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 150, left: 10, right: 10),
    duration: Duration(seconds: 4), // Durasi tampilan SnackBar
  ));
}
