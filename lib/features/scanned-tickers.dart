import 'package:event_tracker/controller/qr_generator.controller.dart';
import 'package:event_tracker/domain/ticket.model.dart';
import 'package:event_tracker/networking.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScannedTickets extends ConsumerStatefulWidget {
  const ScannedTickets({super.key});

  @override
  ConsumerState<ScannedTickets> createState() => _ScannedTicketstate();
}

class _ScannedTicketstate extends ConsumerState<ScannedTickets> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllScannedQr();
  }

  fetchAllScannedQr() async {
    final DioClient client = DioClient();
    final resp = await client.get();
    ref.read(scannedQrList.notifier).state =
        resp.map((res) => TicketModel.fromJson(res)).toList();
    ref.read(scannedQrListLoading.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final ticketList = ref.watch(scannedQrList);
    final isLoading = ref.watch(scannedQrListLoading);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scanned Tickets",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...ticketList
                        .map((ticket) => ticketCard(
                            ticket.ticketId,
                            DateTime.parse(ticket.createdAt)
                                .toIso8601String()
                                .split("T")[0],
                            StringExtension.displayTimeAgoFromTimestamp(
                                ticket.createdAt)))
                        .toList()
                  ],
                ),
              ),
      ),
    );
  }

  Widget ticketCard(final ticketNo, final date, final time) {
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
          boxShadow: [
            const BoxShadow(
              spreadRadius: 4,
              blurRadius: 3,
              color: Colors.grey,
            ),
            const BoxShadow(
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
                Text(
                  "Date: ${date}",
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

    timeAgo = timeValue.toString() + ' ' + timeUnit;
    timeAgo += timeValue > 1 ? 's' : '';

    return timeAgo + ' ago';
  }
}
