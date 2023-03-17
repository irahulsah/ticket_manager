import 'dart:developer';

import 'package:event_tracker/controller/qr_generator.controller.dart';
import 'package:event_tracker/networking.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EventsDropDownField extends ConsumerStatefulWidget {
  final Function onChange;
  const EventsDropDownField({super.key, required this.onChange});

  @override
  ConsumerState<EventsDropDownField> createState() =>
      _EventsDropDownFieldtate();
}

class _EventsDropDownFieldtate extends ConsumerState<EventsDropDownField> {
  bool isLoading = false;
  @override
  void initState() {
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
    if (updatedData != null) {
      isLoading = false;
      ref.read(eventDataProvider.notifier).state = [
        {"name": "All", "_id": ""},
        ...updatedData,
      ];
    }
    isLoading = false;
    setState(() {});
    // ref.read(isLoadingProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.read(isLoadingProvider);
    final events = ref.read(eventDataProvider);
    final eventValue = ref.watch(eventValueDropdown);
    return isLoading
        ? const Center(
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
              ref.read(eventValueDropdown.notifier).state = index.toString();
              widget.onChange(index);
            },
            value: eventValue,
          );
  }
}
