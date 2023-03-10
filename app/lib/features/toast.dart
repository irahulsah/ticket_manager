import 'package:flutter/material.dart';

class CustomScaffoldMessenger {
  CustomScaffoldMessenger.error(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Icon(
              Icons.error,
              color: Colors.white,
            ),
          ),
          Flexible(
            child: Text(
              text,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.redAccent,
    ));
  }
  CustomScaffoldMessenger.info(String text, BuildContext context,
      {bool? canDismiss = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
          Flexible(
            child: Text(
              text,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xff212529),
      // duration: const Duration(milliseconds: 1000),
    ));
  }

  CustomScaffoldMessenger.sucess(String text, BuildContext context,
      {bool? canDismiss = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,

      action: canDismiss == true
          ? SnackBarAction(
              textColor: Colors.white,
              label: "Dismiss",
              onPressed: () {},
            )
          : null,
      content: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
          Flexible(
            child: Text(
              text,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green,
      // duration: const Duration(milliseconds: 1000),
    ));
  }
}
