import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:ui';

import 'package:event_tracker/controller/qr_generator.controller.dart';
import 'package:event_tracker/domain/ticket.model.dart';
import 'package:event_tracker/features/drop_down.dart';
import 'package:event_tracker/features/event_create.screen.dart';
import 'package:event_tracker/features/toast.dart';
import 'package:event_tracker/networking.dart';
import 'package:event_tracker/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:csv/csv.dart';

class QrGeneratorScreen extends ConsumerStatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  ConsumerState<QrGeneratorScreen> createState() => _QrGeneratorScreentate();
}

class _QrGeneratorScreentate extends ConsumerState<QrGeneratorScreen> {
  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  bool isLoading = true;
  bool initStateBool = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initStateBool) {
      fetchData();
    }
    initStateBool = false;
  }

  fetchData() async {
    // ref.read(isLoadingProvider.notifier).state = true;
    isLoading = true;
    final DioClient client = DioClient();
    final updatedData = await client.getEvent();
    if (updatedData != null) {
      isLoading = false;
      ref.read(eventDataProvider.notifier).state = updatedData;
    }
    // ref.read(isLoadingProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final excelFile = ref.watch(excelFileProvider);
    final extractedData = ref.watch(extractedDataFromFile);
    final qrCodes = ref.watch(qrCodesProvider);
    final qrCodesKeys = ref.watch(qrCodesKeysProvider);
    final exampleImg = ref.watch(exampleImages);
    final isLoading = ref.watch(loadingProvider);
    final fillFormManually = ref.watch(fillFormManuallyProvider);
    final fillFormManuallyFields = ref.watch(fillFormManuallyFieldsProvider);

    ScrollController controller = ScrollController();

    Future<List<dynamic>> loadAsset(String path) async {
      final input = File(path).openRead();
      return await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
    }

    void loadCSV(path) async {
      loadAsset(path).then((dynamic rawDataFormatted) {
        var rawData = [];
        for (var element in rawDataFormatted) {
          final index = rawDataFormatted.indexOf(element);
          if (index != 0) {
            rawData.add(TicketModel.fromJson({
              "name": element[1].toString(),
              "email": element[0].toString(),
              "seatNumber": element[2].toString(),
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

    // generate qr code

    generateQrCode() {
      List qrCodes = [];
      List<GlobalKey> keys = [];
      List randomQrUuid = [];
      for (var element in extractedData) {
        var key = GlobalKey();
        final uuidRandom = DateTime.now().millisecondsSinceEpoch +
            Random().nextInt(1000000) +
            500;
        qrCodes.add(RepaintBoundary(
            key: key,
            child: Container(
              color: Colors.white,
              child: Column(children: [
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 30.w,
                        height: 30.h,
                        child: Image.asset(
                          "assets/images/logo.png",
                        )),
                    SizedBox(
                      width: 2.h,
                    ),
                    Text(
                        "Ticket ${(extractedData.indexOf(element) + 1).toString()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent)),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                QrImage(
                  data:
                      "Ticket Booking $uuidRandom\nName: ${element.name}\nEmail: ${element.email}\nseatNumber: ${element.seatNumber}",
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  size: 320,
                  gapless: false,
                )
              ]),
            )));
        keys.add(key);
        randomQrUuid.add(uuidRandom);
      }
      ref.read(qrCodesKeysProvider.notifier).state = keys;
      ref.read(qrCodesProvider.notifier).state = qrCodes;
      ref.read(randomQrUuidProvider.notifier).state = randomQrUuid;
    }

    void takeScreenShot() async {
      PermissionStatus res;
      res = await Permission.storage.request();
      if (res.isGranted) {
        List savedImage = [];
        for (var element in qrCodesKeys) {
          final boundary = element.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
          // We can increse the size of QR using pixel ratio
          final image = await boundary.toImage(pixelRatio: 5.0);
          final byteData =
              await (image.toByteData(format: ImageByteFormat.png));
          if (byteData != null) {
            final pngBytes = byteData.buffer.asUint8List();
            // getting directory of our phone
            final directory = (await getApplicationDocumentsDirectory()).path;
            final imgFile = File(
              '$directory/${DateTime.now()}.png',
            );
            imgFile.writeAsBytes(pngBytes);
            savedImage.add(imgFile);
          }
        }
        ref.read(exampleImages.notifier).state = savedImage;
      }
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "Event Manager",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   backgroundColor: Color.fromARGB(255, 156, 226, 247),
      // ),
      body: ListView(
        controller: controller,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TakeTicketFormPage(),
                  ),
                );
              },
              child: Container(
                height: 40,
                width: 150,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 55, 89, 117),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Text(
                    "Create Event",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: Text(
                      "Upload Csv File",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w400),
                    )),
                    IconButton(
                        onPressed: pickFileContainsExcel,
                        icon: const Icon(Icons.upload)),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Or",
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 10.h,
                ),
                ElevatedButton(
                    onPressed: () {
                      ref.read(extractedDataFromFile.notifier).state = null;
                      ref.read(fillFormManuallyProvider.notifier).state = true;
                      ref.read(fillFormManuallyFieldsProvider.notifier).state =
                          [
                        {"name": "", "seatNumber": "", "email": ""},
                      ];
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Fill form Manuallly"),
                    )),
                Visibility(
                    visible: fillFormManually,
                    child: Form(
                        child: Column(children: [
                      ...fillFormManuallyFields.map((field) {
                        final index = fillFormManuallyFields.indexOf(field);
                        return Column(
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            Text(
                              "Person ${(index + 1).toString()}",
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w400),
                            ),
                            inputField("Full Name", "name", index),
                            inputField("Email", "email", index),
                            inputField("Seat Number", "seatNumber", index),
                          ],
                        );
                      }),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                              onPressed: () {
                                saveManaulFields();
                              },
                              icon: const Icon(Icons.save),
                              label: const Text("Save")),
                          SizedBox(
                            width: 10.w,
                          ),
                          Container(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (fillFormManuallyFields[
                                                fillFormManuallyFields.length -
                                                    1]["name"] ==
                                            "" ||
                                        fillFormManuallyFields[
                                                fillFormManuallyFields.length -
                                                    1]["seatNumber"] ==
                                            "" ||
                                        fillFormManuallyFields[
                                                fillFormManuallyFields.length -
                                                    1]["email"] ==
                                            "") {
                                      CustomScaffoldMessenger.error(
                                          "Please input name, email or seatNumber to continue",
                                          context);
                                      return;
                                    }
                                    ref
                                        .read(fillFormManuallyFieldsProvider
                                            .notifier)
                                        .state = [
                                      ...fillFormManuallyFields,
                                      {
                                        "name": "",
                                        "seatNumber": "",
                                        "email": ""
                                      },
                                    ];
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text("Add"))),
                        ],
                      )
                    ]))),
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
                extractedData == null ? "" : "All Exported Data",
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
                              title: Text(
                                e.name,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.email,
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  if (e.seatNumber != "")
                                    Text(
                                      "Seat: ${e.seatNumber}",
                                      style: TextStyle(fontSize: 15.sp),
                                    )
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    )),
          Visibility(
              visible: extractedData != null,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
                      child: const DropDownField())),
          Visibility(
              visible: extractedData != null,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                color: const Color.fromARGB(255, 195, 211, 240),
                child: TextButton.icon(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      if (ref.read(eventValueDropdown.notifier).state == "") {
                        CustomScaffoldMessenger.error(
                            "Please select event to continue", context);
                        return;
                      }
                      generateQrCode();
                    },
                    icon: const Icon(Icons.generating_tokens),
                    label: const Text("Generate Tickets")),
              )),
          Visibility(
              visible: qrCodes.length != 0,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.r),
                  alignment: Alignment.center,
                  child: Column(
                    children: [...qrCodes],
                  ))),
          Visibility(
            visible: exampleImg.length != 0,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 60.w, vertical: 20.h),
                color: const Color.fromARGB(255, 195, 211, 240),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    handleSubmit(ref, context);
                  },
                  icon: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Icon(Icons.send_rounded),
                  label: const Text("Send Tickets"),
                )),
          )
        ],
      ),
      floatingActionButton: Visibility(
          visible: qrCodes.length != 0 && exampleImg.length == 0,
          child: CircleAvatar(
            maxRadius: 30,
            child: IconButton(
              color: Colors.white,
              onPressed: () {
                takeScreenShot();
                controller.jumpTo(controller.position.maxScrollExtent + 200);
              },
              icon: const Icon(Icons.save),
            ),
          )),
    );
  }

  Widget inputField(String hintText, String name, index) {
    final fillFormManuallyFields = ref.watch(fillFormManuallyFieldsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: (dynamic value) {
            if (value?.isEmpty) {
              return "Event Name is required.";
            }
            return null;
          },
          // controller: controller,
          style: const TextStyle(
            fontSize: 18,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 15.h,
              horizontal: 15.w,
            ),
            hintText: "Event Name",
            hintStyle: TextStyle(
              // color: Theme.of(context).colorScheme.tertiary,
              fontSize: 16.sp,
            ),
            border: OutlineInputBorder(
              // borderSide: BorderSide.a,
              borderRadius: BorderRadius.circular(12.r),
            ),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                width: 2.w,
              ),
            ),
          ),
          onChanged: (String value) {
            final copyManualFieldValue = fillFormManuallyFields;
            copyManualFieldValue[index][name] = value;
            ref.read(fillFormManuallyFieldsProvider.notifier).state =
                copyManualFieldValue;
          },
        ),
      ],
    );
  }

  saveManaulFields() {
    CustomScaffoldMessenger.sucess("User Saved Successfully", context);
    ref.read(fillFormManuallyProvider.notifier).state = false;
    ref.read(extractedDataFromFile.notifier).state = ref
        .read(fillFormManuallyFieldsProvider.notifier)
        .state
        .map((field) => TicketModel.fromJson(field))
        .toList();
    ref.read(fillFormManuallyFieldsProvider.notifier).state = [];
  }

  handleSubmit(ref, context) async {
    final exampleImg = ref.watch(exampleImages);
    final randomQrUuid = ref.watch(randomQrUuidProvider);
    final eventValue = ref.watch(eventValueDropdown);
    ref.read(loadingProvider.notifier).state = true;
    final DioClient client = DioClient();
    final uploadedImages = await client.uploadImages(exampleImg);
    final userData = await ref.watch(extractedDataFromFile);
    List newFilterUserData = [];
    for (var user in userData) {
      final index = userData.indexOf(user);
      newFilterUserData.add({
        ...user.toJson(),
        "event": eventValue,
        "qr_code": uploadedImages[index],
        "uniqueUUid": randomQrUuid[index]
      });
    }
    try {
      await client.createTickets(newFilterUserData);
      ref.read(loadingProvider.notifier).state = false;
      ref.refresh(excelFileProvider);
      ref.refresh(extractedDataFromFile);
      ref.refresh(qrCodesProvider);
      ref.refresh(qrCodesKeysProvider);
      ref.refresh(exampleImages);
      ref.refresh(randomQrUuidProvider);
      // ignore: use_build_context_synchronously
      alertDialog(context, ref);
    } catch (e) {
      ref.read(loadingProvider.notifier).state = false;
      CustomScaffoldMessenger.error("Invalid Credentails", context);
    }
  }
}
