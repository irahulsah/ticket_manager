import 'package:event_tracker/constant.dart';
import 'package:event_tracker/features/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

StateProvider bottomNavIndex = StateProvider<int>((ref) => 0);

class TakeTicket extends ConsumerWidget {
  const TakeTicket({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndex);
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 0,
        title: Row(
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 25.h,
              width: 25.w,
            ),
            SizedBox(
              width: 3.w,
            ),
            Text(
              bottomNavWidgets[currentIndex]["title"],
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                final box = GetStorage();
                box.remove("accessToken");
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              icon: const Icon(
                Icons.logout,
                size: 20,
                color: Colors.black,
              )),
          SizedBox(
            width: 5.w,
          )
        ],
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 156, 226, 247),
        elevation: 0,
      ),
      body: bottomNavWidgets[currentIndex]["widget"],
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.qr_code_outlined,
          size: 40,
        ),
        tooltip: 'Increment',
        elevation: 2.0,
        backgroundColor: Colors.purple[900],
        onPressed: () {
          ref.read(bottomNavIndex.notifier).state = 1;

          // setState(
          //   () {
          //     currentScreen = Profile();
          //     currentTab = 0;
          //   },
          // );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(bottomNavIndex.notifier).state = index;
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code, size: 0), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_card), label: "Tickets"),
            ]),
      ),
    );
  }
}
