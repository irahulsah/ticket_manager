import 'package:event_tracker/controller/qr_generator.controller.dart';
import 'package:event_tracker/features/login.dart';
import 'package:event_tracker/features/toast.dart';
import 'package:event_tracker/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    final isLoading = ref.watch(isLoadingProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: 100.h,
                      ),
                    ),
                    SizedBox(height: 40.h),
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

                    inputField(firstNameController, false,
                        "Enter First name"), //Name TextBox
                    inputField(lastNameController, false,
                        "Enter Last name"), //Name TextBox
                    inputField(
                        emailController, false, "Enter email"), //Email TextBox
                    inputField(passwordController, false,
                        "Enter password"), //Password TextBox

                    //Login button
                    GestureDetector(
                      onTap: () async {
                        final form = formKey.currentState;
                        if (form!.validate()) {
                          ref.read(isLoadingProvider.notifier).state = true;

                          final DioClient client = DioClient();
                          try {
                            await client.signup({
                              "email": emailController.text,
                              "password": passwordController.text,
                              "firstName": firstNameController.text,
                              "lastName": lastNameController.text,
                            });
                            if (context.mounted) {
                              ref.read(isLoadingProvider.notifier).state =
                                  false;

                              CustomScaffoldMessenger.sucess(
                                  "Your Account is created.Please login",
                                  context);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            }
                          } catch (e) {
                            ref.read(isLoadingProvider.notifier).state = false;
                            CustomScaffoldMessenger.error(
                                e.toString(), context);
                          }
                        } else {}
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 55, 89, 117),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Signup",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Visibility(
                                visible: isLoading,
                                child: const CircularProgressIndicator(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Login(),
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
              )),
        ),
      ),
    );
  }

  Widget inputField(
      TextEditingController controller, bool? isObscure, String labelText) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      child: TextFormField(
        validator: (dynamic value) {
          if (value?.isEmpty) {
            return "$labelText is required.";
          }
          return null;
        },
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
