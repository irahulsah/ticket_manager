// To parse this JSON data, do
//
//     final ticketModel = ticketModelFromJson(jsonString);

import 'dart:convert';

TicketModel ticketModelFromJson(String str) =>
    TicketModel.fromJson(json.decode(str));

String ticketModelToJson(TicketModel data) => json.encode(data.toJson());

class TicketModel {
  TicketModel({
    required this.email,
    required this.name,
    this.ticketId,
    this.createdAt,
    this.scannedBy,
    this.seatNumber,
    required this.event,
    // this.tickerId,
  });

  String email;
  String name;
  String? ticketId;
  String? createdAt;
  String event;
  String? scannedBy;
  String? seatNumber;
  // String? tickerId;

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        email: json["email"],
        name: json["name"],
        ticketId: json["ticketId"],
        createdAt: json["createdAt"],
        seatNumber: json["seatNumber"],
        event: json["event"] == null ? "" : json["event"]["name"],
        scannedBy: json["scanned_by"] == null
            ? ""
            : json["scanned_by"]["firstName"] +
                " " +
                json["scanned_by"]["lastName"],
        // tickerId: json["ticket_id"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "ticketId": ticketId,
        "createdAt": createdAt,
        "event": event,
        "scannedBy": scannedBy,
        "seatNumber": seatNumber,
        // "ticket_id": tickerId,
      };
}
