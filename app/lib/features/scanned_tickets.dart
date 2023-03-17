import 'dart:developer';

import 'package:event_tracker/controller/qr_generator.controller.dart';
import 'package:event_tracker/domain/ticket.model.dart';
import 'package:event_tracker/features/events_drop_down.dart';
import 'package:event_tracker/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ScannedTickets extends ConsumerStatefulWidget {
  const ScannedTickets({super.key});

  @override
  ConsumerState<ScannedTickets> createState() => _ScannedTicketstate();
}

class _ScannedTicketstate extends ConsumerState<ScannedTickets> {
  final DioClient client = DioClient();
  @override
  void initState() {
    super.initState();
    fetchAllScannedQr();
    fetchCountOfTicket();
  }

  fetchCountOfTicket() async {
    final count = [client.getScannedTicketPercentage()];
    Future.wait(count).then((resp) {
      ref.read(scannedPercentageProvider.notifier).state = resp[0];
    });
  }

  fetchAllScannedQr() async {
    try {
      final resp = await client.getTicket();
      ref.read(scannedQrList.notifier).state =
          resp.map((res) => TicketModel.fromJson(res)).toList();
      ref.read(scannedQrListLoading.notifier).state = false;
    } catch (e) {
      ref.read(scannedQrListLoading.notifier).state = false;
    }
  }

  onChange(event) async {
    ref.read(scannedQrListLoading.notifier).state = true;

    try {
      List<Future> futures = [
        client.getTicket(event: event),
        client.getScannedTicketPercentage(event: event),
      ];
      final resp = await Future.wait(futures);

      ref.read(scannedQrList.notifier).state =
          resp[0].map((res) => TicketModel.fromJson(res)).toList();
      ref.read(scannedPercentageProvider.notifier).state = resp[1];
      ref.read(scannedQrListLoading.notifier).state = false;
    } catch (e) {
      ref.read(scannedQrListLoading.notifier).state = false;
    }
  }

  /// Returns the marker pointer gauge
  SfRadialGauge _buildMarkerPointerExample() {
    final scannedPercentage = ref.watch(scannedPercentageProvider);
    log("scannedPercentage $scannedPercentage");
    return SfRadialGauge(
      title: GaugeTitle(
          text: "Tickets Scanned",
          textStyle: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          )),
      axes: <RadialAxis>[
        RadialAxis(
            startAngle: 180,
            endAngle: 360,
            radiusFactor: 0.9,
            canScaleToFit: true,
            interval: 10,
            showLabels: false,
            showAxisLine: false,
            pointers: <GaugePointer>[
              MarkerPointer(
                  value: scannedPercentage == "NaN"
                      ? 0
                      : double.parse(scannedPercentage.toString()),
                  elevation: 4,
                  markerWidth: 25,
                  markerHeight: 25,
                  color: const Color(0xFFF67280),
                  markerType: MarkerType.invertedTriangle,
                  markerOffset: -7)
            ],
            annotations: <GaugeAnnotation>[
              const GaugeAnnotation(
                  angle: 175,
                  positionFactor: 0.8,
                  widget: Text('Min',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold))),
              GaugeAnnotation(
                  angle: 270,
                  positionFactor: 0.1,
                  widget: Text(
                      '${scannedPercentage == "NaN" ? 0 : double.parse(scannedPercentage.toString()).toStringAsFixed(2)}%',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold))),
              const GaugeAnnotation(
                  angle: 5,
                  positionFactor: 0.8,
                  widget: Text('Max',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))
            ],
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 100,
                sizeUnit: GaugeSizeUnit.factor,
                gradient: const SweepGradient(
                    colors: <Color>[Color(0xFFAB64F5), Color(0xFF62DBF6)],
                    stops: <double>[0.25, 0.75]),
                startWidth: 0.4,
                endWidth: 0.4,
                color: const Color(0xFF00A8B5),
              )
            ],
            showTicks: false),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticketList = ref.watch(scannedQrList);
    final isLoading = ref.watch(scannedQrListLoading);
    return SingleChildScrollView(
      child: isLoading
          ? Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 200.h),
              child: const CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.zero,
                      height: 250.h,
                      child: _buildMarkerPointerExample()),
                  Text(ticketList.length.toString(),
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.w500)),
                  Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      alignment: Alignment.topRight,
                      child: EventsDropDownField(
                        onChange: onChange,
                      )),
                  ticketList.isEmpty
                      ? Container(
                          margin: EdgeInsets.only(top: 30.h),
                          alignment: Alignment.center,
                          child: Text(
                            "No Scanned tickets",
                            style: TextStyle(fontSize: 20.sp),
                          ))
                      : Column(children: [
                          ...ticketList
                              .map((ticket) => ticketCard(
                                  ticket.ticketId,
                                  DateTime.parse(ticket.createdAt)
                                      .toIso8601String()
                                      .split("T")[0],
                                  StringExtension.displayTimeAgoFromTimestamp(
                                      ticket.createdAt),
                                  ticket.event,
                                  ticket.scannedBy,
                                  ticket.seatNumber))
                              .toList()
                        ])
                ],
              ),
            ),
    );
  }

  Widget ticketCard(
      final ticketNo, final date, final time, event, scannedBy, seatNumber) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      margin: const EdgeInsets.only(
        bottom: 30,
      ),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 242, 237),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              spreadRadius: 4,
              blurRadius: 3,
              color: Colors.grey,
            ),
            BoxShadow(
              spreadRadius: 4,
              blurRadius: 3,
              color: Colors.green,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$ticketNo",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (seatNumber != null)
                  Text(
                    "SeatNumber: $seatNumber",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  "Event: $event",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "scanned By: $scannedBy",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Date: $date",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "$time",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  static String displayTimeAgoFromTimestamp(String timestamp) {
    final year = int.parse(timestamp.substring(0, 4));
    final month = int.parse(timestamp.substring(5, 7));
    final day = int.parse(timestamp.substring(8, 10));
    final hour = int.parse(timestamp.substring(11, 13));
    final minute = int.parse(timestamp.substring(14, 16));

    final DateTime videoDate = DateTime(year, month, day, hour, minute);
    final int diffInHours = DateTime.now().difference(videoDate).inHours;

    String timeAgo = '';
    String timeUnit = '';
    int timeValue = 0;

    if (diffInHours < 1) {
      final diffInMinutes = DateTime.now().difference(videoDate).inMinutes;
      timeValue = diffInMinutes;
      timeUnit = 'minute';
    } else if (diffInHours < 24) {
      timeValue = diffInHours;
      timeUnit = 'hour';
    } else if (diffInHours >= 24 && diffInHours < 24 * 7) {
      timeValue = (diffInHours / 24).floor();
      timeUnit = 'day';
    } else if (diffInHours >= 24 * 7 && diffInHours < 24 * 30) {
      timeValue = (diffInHours / (24 * 7)).floor();
      timeUnit = 'week';
    } else if (diffInHours >= 24 * 30 && diffInHours < 24 * 12 * 30) {
      timeValue = (diffInHours / (24 * 30)).floor();
      timeUnit = 'month';
    } else {
      timeValue = (diffInHours / (24 * 365)).floor();
      timeUnit = 'year';
    }

    timeAgo = '$timeValue $timeUnit';
    timeAgo += timeValue > 1 ? 's' : '';

    return '$timeAgo ago';
  }
}
