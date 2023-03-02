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
    // this.tickerId,
  });

  String email;
  String name;
  // String? tickerId;

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        email: json["email"],
        name: json["name"],
        // tickerId: json["ticket_id"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        // "ticket_id": tickerId,
      };
}
