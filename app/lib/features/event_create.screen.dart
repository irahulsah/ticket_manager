import 'package:event_tracker/features/qr_generator.dart';
import 'package:event_tracker/features/scanned-tickers.dart';
import 'package:event_tracker/features/toast.dart';
import 'package:event_tracker/networking.dart';
import 'package:flutter/material.dart';

class TakeTicketFormPage extends StatefulWidget {
  const TakeTicketFormPage({super.key});

  @override
  State<TakeTicketFormPage> createState() => _TakeTicketFormPageState();
}

class _TakeTicketFormPageState extends State<TakeTicketFormPage> {
  TextEditingController _scannedByController = TextEditingController();
  bool isLoading = false;
  TextEditingController _eventsController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    _scannedByController = TextEditingController();
    _eventsController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scannedByController.dispose();
    super.dispose();
  }

  handleSubmit() async {
    setState(() {
      isLoading = true;
    });
    final DioClient client = DioClient();
    final updatedData =
        await client.createEvent({"name": _eventsController.text});
    // ignore: use_build_context_synchronously
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QrGeneratorScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 156, 226, 247),
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
                  color: Color.fromARGB(255, 156, 226, 247),
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
      ),
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
          "$hintText",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
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
