import 'dart:developer';

import 'package:event_tracker/features/login.dart';
import 'package:event_tracker/features/signup.dart';
import 'package:event_tracker/features/take-ticket.dart';
import 'package:event_tracker/features/toast.dart';
import 'package:event_tracker/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = GetStorage();
      final isLoggedIn = box.read("accessToken") != null;
      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const TakeTicket(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
              // padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: const Text("Welcome to ticket manager"))),
    );
  }
}
