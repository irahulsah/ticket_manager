import 'package:event_tracker/features/qr_generator.dart';
import 'package:event_tracker/features/scan_qr.dart';
import 'package:event_tracker/features/scanned_tickets.dart';

List bottomNavWidgets = [
  {"widget": const ScannedTickets(), "title": "Event Manager"},
  {"widget": const ScanQrPage(), "title": "Scan Tickets"},
  {"widget": const QrGeneratorScreen(), "title": "Generate tickets"},
];
