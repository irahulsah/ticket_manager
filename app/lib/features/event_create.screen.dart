import 'dart:developer';

import 'package:event_tracker/controller/qr_generator.controller.dart';
import 'package:event_tracker/networking.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TakeTicketFormPage extends ConsumerStatefulWidget {
  const TakeTicketFormPage({super.key});

  @override
  ConsumerState<TakeTicketFormPage> createState() => _TakeTicketFormPagetate();
}

class _TakeTicketFormPagetate extends ConsumerState<TakeTicketFormPage> {
  TextEditingController _scannedByController = TextEditingController();
  bool isLoading = false;
  TextEditingController _eventsController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _scannedByController = TextEditingController();
    _eventsController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _scannedByController.dispose();
    super.dispose();
  }

  handleSubmit() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });
      final DioClient client = DioClient();

      final respData =
          await client.createEvent({"name": _eventsController.text});
      // ignore: use_build_context_synchronously
      setState(() {
        isLoading = false;
      });
      if (context.mounted) {
        final previousData = ref.watch(eventDataProvider);
        log("$previousData $respData");
        ref.read(eventDataProvider.notifier).state = [
          ...previousData,
          respData
        ];
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 156, 226, 247),
        title: const Text(
          "Event Creator Page",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // inputField("Scanned By", _scannedByController),
                // const SizedBox(
                //   height: 20,
                // ),
                inputField("Event Name", _eventsController),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: isLoading
                      ? () {}
                      : () {
                          handleSubmit();
                        },
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 156, 226, 247),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: Text(
                      isLoading ? "Creating.." : "Sumbit",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    )),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget inputField(
    String hintText,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: (dynamic value) {
            if (value?.isEmpty) {
              return "Event Name is required.";
            }
            return null;
          },
          controller: controller,
          style: const TextStyle(
            fontSize: 18,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
              left: 10,
            ),
            border: InputBorder.none,
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
