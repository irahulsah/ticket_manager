import 'package:flutter/material.dart';

class ScannedTickets extends StatelessWidget {
  const ScannedTickets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scanned Tickets",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ticketCard("JHDGJFGKLA32484900", "03/03/2022", "5:06PM"),
            ticketCard("JHDGJFGKLA32484900", "03/03/2022", "5:06PM"),
            ticketCard("JHDGJFGKLA32484900", "03/03/2022", "5:06PM"),
          ],
        ),
      ),
    );
  }

  Widget ticketCard(final ticketNo, final date, final time) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      margin: EdgeInsets.only(
        bottom: 30,
      ),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 243, 242, 237),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
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
                  "Ticket No.: ${ticketNo.toString()}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Date: ${date}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "$time",
            style: TextStyle(
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
