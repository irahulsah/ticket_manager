import 'dart:io';
import 'dart:developer';
import 'package:event_tracker/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrPage extends ConsumerStatefulWidget {
  const ScanQrPage({super.key});

  @override
  ConsumerState<ScanQrPage> createState() => _ScanQrPagetate();
}

class _ScanQrPagetate extends ConsumerState<ScanQrPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void _onQRViewCreated(QRViewController controller) {
    final DioClient client = DioClient();
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) async {
      setState(() => result = scanData);
      if (!scanData.code!.split("\n")[0].split(" ")[0].contains("Ticket") &&
          !scanData.code!.split("\n")[0].split(" ")[0].contains("Booking")) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/icons/close.png",
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(height: 20.h),
                      const Text(
                        "Qr code is invalid.",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        controller.resumeCamera();
                        result = null;
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.cyan, fontSize: 17),
                      ),
                    ),
                  ],
                ));
        return;
      }
      try {
        log("scanDatcodea ${scanData.code} ${scanData.code!.split("\n")[0].split(" ").last}");
        final updatedData = await client
            .updateScannedStatus(scanData.code!.split("\n")[0].split(" ").last);
        log("updatedData ${updatedData}");

        // ignore: use_build_context_synchronously
        showModalBottomSheet(
            isDismissible: false,
            context: context,
            shape: const RoundedRectangleBorder(
              // <-- SEE HERE
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            builder: (ctx) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Image.asset(
                        "assets/icons/checked.png",
                        width: 70,
                        height: 70,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Text(
                        "Ticket Scanned Successfully.",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                    ),

                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "Ticket Number: ${updatedData["ticketId"]}",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Seat Number: ${updatedData["seatNumber"]}",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Customer Name: ${updatedData["name"]}",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Customer Email: ${updatedData["email"]}",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w400),
                    ),
                    // ...scanData.code!.split("/n").map((e) => Container(
                    //       margin: const EdgeInsets.all(12.0),
                    //       child: Text(
                    //         e,
                    //         style: TextStyle(
                    //             fontSize: 15.sp, fontWeight: FontWeight.w400),
                    //       ),
                    //     )),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Created Ticket: ${updatedData["createdAt"].split("T")[0]}",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          controller.resumeCamera();
                          result = null;
                        },
                        child: const Text("Continue")),
                  ],
                ),
              );
            });
      } catch (e) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/icons/close.png",
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(height: 20.h),
                      const Text(
                        "Ticket is expired.",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        controller.resumeCamera();
                        result = null;
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.cyan, fontSize: 17),
                      ),
                    ),
                  ],
                ));
      }
    });
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void readQr() async {
    if (result != null) {
      controller!.pauseCamera();
    }
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    if (result != null) {
      return false; // return true if the route to be popped
    } else {
      return true;
    }
  }

  bool initStateBool = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initStateBool) {
      controller?.resumeCamera();
    }
    initStateBool = false;
  }

  @override
  Widget build(BuildContext context) {
    readQr();
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          body: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.orange,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 250,
            ),
          ),
        ));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
