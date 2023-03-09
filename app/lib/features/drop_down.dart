import 'dart:developer';

import 'package:event_tracker/controller/qr_generator.controller.dart';
import 'package:event_tracker/networking.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DropDownField extends ConsumerStatefulWidget {
  const DropDownField({super.key});

  @override
  ConsumerState<DropDownField> createState() => _DropDownFieldtate();
}

class _DropDownFieldtate extends ConsumerState<DropDownField> {
  String? dropDownIndex;
  var dropDownList = ["Delete", "Change", "Remove", "Save"];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  fetchData() async {
    // ref.read(isLoadingProvider.notifier).state = true;
    isLoading = true;
    final DioClient client = DioClient();
    final updatedData = await client.getEvent();
    log("data $updatedData");
    if (updatedData != null) {
      isLoading = false;
      ref.read(eventDataProvider.notifier).state = updatedData;
    }
    setState(() {});
    // ref.read(isLoadingProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.read(isLoadingProvider);
    final events = ref.read(eventDataProvider);
    log("$events    shshsh");
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : DropdownButton(
            icon: const Icon(Icons.expand_circle_down),
            dropdownColor: Colors.white,
            hint: const Text("Select Event"),
            enableFeedback: true,
            iconSize: 16,
            borderRadius: BorderRadius.circular(16),
            style: const TextStyle(
              color: Colors.blueAccent,
              // decoration: TextDecoration.underline,
              // decorationColor: Colors.yellow,
            ),
            items: events
                .map<DropdownMenuItem<String>>((value) => DropdownMenuItem(
                      value: value["_id"].toString(),
                      child: Text(value["name"].toString()),
                    ))
                .toList(),
            onChanged: (String? index) {
              ref.read(eventValueDropdown.notifier).state = index;
              setState(() {
                dropDownIndex = index;
              });
            },
            value: dropDownIndex,
          );
  }
}