import 'package:event_tracker/constant.dart';
import 'package:event_tracker/features/faq.dart';
import 'package:event_tracker/features/login.dart';
import 'package:event_tracker/features/report_problem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

StateProvider bottomNavIndex = StateProvider<int>((ref) => 0);

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndex);
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 100.h,
                    ),
                  ),
                  Text(
                    'Event Manager',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.report,
              ),
              title: const Text('Report a Problem'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ReportAProblem(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.help_center,
              ),
              title: const Text("FAQ'S"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FAQS(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
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
        tooltip: 'Increment',
        elevation: 2.0,
        backgroundColor: Colors.purple[900],
        onPressed: () {
          ref.read(bottomNavIndex.notifier).state = 1;
        },
        child: const Icon(
          Icons.qr_code_outlined,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomNavigationBar(
            elevation: 2,
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
