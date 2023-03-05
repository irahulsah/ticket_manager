import 'package:event_tracker/features/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Signup to\nticket Manager",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40.h),
              // Text(
              //   "Login to your\naccount",
              //   style: TextStyle(
              //     fontSize: 28.sp,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(height: 80.h),

              inputField(
                  nameController, false, "Enter full name"), //Name TextBox
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
                    "Signup",
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
                      builder: (context) => Login(),
                    ),
                  );
                },
                child: Text(
                  "Already registered user? Login",
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
