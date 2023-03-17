import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

class FAQS extends StatefulWidget {
  const FAQS({super.key});

  @override
  State<FAQS> createState() => _FAQSState();
}

class _FAQSState extends State<FAQS> {
  var imageUrl =
      "https://www.itl.cat/pngfile/big/10-100326_desktop-wallpaper-hd-full-screen-free-download-full.jpg";
  bool downloading = false;
  String downloadingStr = "No data";
  String savePath = "";
  Future downloadFile() async {
    try {
      Dio dio = Dio();

      String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);

      savePath = await getFilePath(fileName);
      await dio.download(imageUrl, savePath, onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          // download = (rec / total) * 100;
          downloadingStr = "Downloading Image : $rec";
        });
      });
      setState(() {
        downloading = false;
        downloadingStr = "Completed";
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory dir = await getApplicationDocumentsDirectory();

    path = '${dir.path}/$uniqueFileName';

    return path;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ's"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: downloading
              ? SizedBox(
                  height: 250,
                  width: 250,
                  child: Card(
                    color: Colors.pink,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          downloadingStr,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )
              : Column(children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          downloading = true;
                        });
                        downloadFile();
                      },
                      icon: Icon(Icons.download),
                      label: Text("Download Sample Csv")),
                  SizedBox(
                    height: 7.h,
                  ),
                  Text(
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4),
                      "Here's an example of the content for each section on how to use a ticket scanning application:\n\n1st section: Login and Signup\n\nTo use the ticket scanning application, you'll need to create an account by signing up with your email address and creating a password. If you already have an account, simply log in using your email and password.\n\n2nd section: Generate Ticket > Create Event > Upload Excel File > Generate Ticket > Send Mail\n\nStep 1: Generate Ticket\nOnce you're logged in,\n\nclick on the Generate Ticket button on the home screen. This will take you to a form where you can enter the ticket details such as ticket name, ticket price, and the number of tickets available.\n\nStep 2: Create Event\nAfter creating the ticket, click on the Create Event button to set up the event details. Enter the event name, date, time, location, and any other relevant information.\n\nStep 3: Upload Excel File If you have a large number of tickets to generate, you can upload an Excel file with the details of each ticket. This will save you time and ensure accuracy.\n\nStep 4: Generate Ticket\nOnce you've entered all the required information, click on the Generate Ticket button to create the tickets. You can download the tickets in PDF format or email them to the attendees.\n"),
                  Text(
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4),
                      "Step 5: Send Mail If you choose to email the tickets, you can do so by clicking on the Send Mail  button.\nThis will send an email to each attendee with their ticket attached."),
                  Text(
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4),
                      "\n3rd section: Scan Ticket by Scanner To scan a ticket, open the ticket scanning application and click on the Scan Ticket button.\n\nUse your device's camera to scan the QR code on the ticket. The application will verify the ticket's authenticity and validity.\n\nIf the ticket is valid, the attendee can be granted entry to the event.\n\nIf the ticket is invalid or has already been scanned, an alert will be generated, and the attendee will not be granted entry.")
                ]),
        ),
      ),
    );
  }
}
