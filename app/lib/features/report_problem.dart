import 'dart:developer';

import 'package:event_tracker/controller/qr_generator.controller.dart';
import 'package:event_tracker/features/homepage.dart';
import 'package:event_tracker/features/toast.dart';
import 'package:event_tracker/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReportAProblem extends ConsumerStatefulWidget {
  const ReportAProblem({super.key});

  @override
  ConsumerState<ReportAProblem> createState() => _ReportAProblemtate();
}

class _ReportAProblemtate extends ConsumerState<ReportAProblem> {
  TextEditingController _scannedByController = TextEditingController();
  bool isLoading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _reasonControler = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _scannedByController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _reasonControler = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _scannedByController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _reasonControler.dispose();
    super.initState();
    super.dispose();
  }

  handleSubmit() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });
      final DioClient client = DioClient();

      final respData = await client.reportAProblem({
        "name": _nameController.text,
        "email": _emailController.text,
        "phoneNumber": _phoneNumberController.text,
        "reason": _reasonControler.text
      });
      // ignore: use_build_context_synchronously
      setState(() {
        isLoading = false;
      });
      if (respData != null && context.mounted) {
        CustomScaffoldMessenger.sucess(
            "You have reported succesfully, we will contact soon.", context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 156, 226, 247),
        title: const Text(
          "Report a Problem",
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
                inputField("Full Name", _nameController),
                inputField("Email", _emailController),
                inputField("Phone Number", _phoneNumberController),
                inputField("Reason", _reasonControler),
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
                      isLoading ? "reporting.." : "Sumbit",
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
            contentPadding: EdgeInsets.symmetric(
              vertical: 15.h,
              horizontal: 15.w,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              // color: Theme.of(context).colorScheme.tertiary,
              fontSize: 16.sp,
            ),
            border: OutlineInputBorder(
              // borderSide: BorderSide.a,
              borderRadius: BorderRadius.circular(12.r),
            ),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                width: 2.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
