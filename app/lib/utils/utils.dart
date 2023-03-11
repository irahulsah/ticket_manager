import 'package:event_tracker/features/take_ticket.dart';
import 'package:flutter/material.dart';

alertDialog(BuildContext context, ref) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Done'),
          content: const Text('Ticket has been sent to users successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
                ref.read(bottomNavIndex.notifier).state = 0;
              },
            ),
          ],
        );
      });
}
