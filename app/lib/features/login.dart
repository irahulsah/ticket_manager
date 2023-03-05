import 'package:event_tracker/features/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/ticket.jpg",
                  height: 100.h,
                ),
              ),
              Center(
                child: Text(
                  "Ticket Manager",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 80.h),
              // Text(
              //   "Login to your\naccount",
              //   style: TextStyle(
              //     fontSize: 28.sp,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(height: 80.h),

              inputField(emailController, false, "Enter email"), //Email TextBox

              inputField(passwordController, false,
                  "Enter password"), //Password TextBox

              //Login button
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 55, 89, 117),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Signup(),
                    ),
                  );
                },
                child: Text(
                  "New User? Signup",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputField(
      TextEditingController controller, bool? isObscure, String labelText) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      child: TextField(
        controller: controller,
        style: TextStyle(
          // color: Theme.of(context).colorScheme.outline,
          fontSize: 14.sp,
        ),
        obscureText: isObscure ?? false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 15.w,
          ),
          hintText: labelText,
          hintStyle: TextStyle(
            // color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
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
        onChanged: (value) {},
      ),
    );
  }
}
