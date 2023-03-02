import 'package:event_tracker/controller/qr_generator.controller.dart';
import 'package:event_tracker/domain/ticket.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;

class QrGeneratorScreen extends ConsumerWidget {
  const QrGeneratorScreen({super.key});

  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final excelFile = ref.watch(excelFileProvider);

    Future<String> loadAsset(String path) async {
      return await rootBundle.loadString(path);
    }

    void loadCSV(path) {
      loadAsset(path).then((dynamic output) {
        var rawData = [];
        final rawDataFormatted = output.split("\n");
        for (var element in rawDataFormatted) {
          final index = rawDataFormatted.indexOf(element);
          if (index != 0) {
            rawData.add(TicketModel.fromJson({
              "name": element.split(",")[1].toString(),
              "email": element.split(",")[0].toString(),
            }));
          }
        }

        ref.read(extractedDataFromFile.notifier).state = rawData;
      });
    }

    // pick an excel file from the device to take all the list of users and their detail
    pickFileContainsExcel() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv'],
      );

      if (result != null) {
        ref.read(excelFileProvider.notifier).state = result.files.single;
        loadCSV(result.files.single.path);
      } else {
        // User canceled the picker
      }
    }

    final extractedData = ref.watch(extractedDataFromFile);

    return Scaffold(
      appBar: AppBar(title: const Text("Event Manager")),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(child: Text("Import File")),
                IconButton(
                    onPressed: pickFileContainsExcel,
                    icon: const Icon(Icons.upload)),
              ],
            ),
          ),
          Visibility(
              visible: excelFile != null,
              child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black)),
                  child: Text(
                    excelFile == null ? "NA" : excelFile.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.sp),
                  ))),
          Container(
              margin: EdgeInsets.only(left: 20.w, top: 20.h),
              child: Text(
                "All Exported Data",
                style: TextStyle(fontSize: 16.sp),
              )),
          SizedBox(
            height: 20.h,
          ),
          Visibility(
              visible: extractedData != null,
              child: extractedData == null
                  ? const Center(
                      child: Text("No Results yet!"),
                    )
                  : Column(
                      children: extractedData
                          ?.map<Widget>(
                            (e) => ListTile(
                              leading: CircleAvatar(
                                  child: Text(e.name[0].toUpperCase())),
                              title: Text(e.name),
                              subtitle: Text(e.email),
                            ),
                          )
                          .toList(),
                    )),
          Visibility(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            color: const Color.fromARGB(255, 195, 211, 240),
            child: TextButton.icon(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                onPressed: () {},
                icon: const Icon(Icons.generating_tokens),
                label: const Text("Generate Tickets")),
          ))
        ],
      ),
    );
  }
}
