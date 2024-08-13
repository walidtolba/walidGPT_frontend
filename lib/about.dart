import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walidgpt/globals.dart';

Widget showAbout(BuildContext context) {
  return Dialog(
    backgroundColor: (!isDark)? lightTheme['background']: darkTheme['background'],
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 470,
        padding: EdgeInsets.fromLTRB(40, 16, 40, 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ABOUT',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
            ),
            SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/images/logo.jpg',
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            SizedBox(
              height: 30,
            ),
            Text('This Application is a mini project for SDIA students.', style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Created By:', style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Walid Tolba', style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
                    SizedBox(
                      height: 4,
                    ),
                    Text('Farouk Zaouak', style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Supervisor:', style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dr K. Necibi', style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            TextButton(
                child: Text('Rate us in google play'),
                onPressed: () async {
                  try {
                    Uri browserUri =
                        Uri(scheme: 'https', path: "play.google.com/");
                    await launchUrl(browserUri);
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                })
          ],
        )),
  );
}


Widget showAboutArabic(BuildContext context) {
  return Dialog(
    backgroundColor: (!isDark)? lightTheme['background']: darkTheme['background'],
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 480,
        padding: EdgeInsets.fromLTRB(40, 16, 40, 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'حول',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
            ),
            SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/images/logo.jpg',
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            SizedBox(
              height: 30,
            ),
            Text('هذا التطبيق هو مشروع صغير لطلاب SDIA.', textDirection: TextDirection.rtl, style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('وليد طلبة', textDirection: TextDirection.rtl, style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
                    SizedBox(
                      height: 4,
                    ),
                    Text('فاروق ذوق', textDirection: TextDirection.rtl, style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
                  ],
                ),SizedBox(
                  width: 60,
                ),Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('انشأ من قبل:', textDirection: TextDirection.rtl, style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الدكتور ك. نجيبي', textDirection: TextDirection.rtl, style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
                  ],
                ),SizedBox(
                  width: 60,
                ),Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('مشرف:', textDirection: TextDirection.rtl, style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            TextButton(
                child: Text('قيمنا في جوجل بلاي', textDirection: TextDirection.rtl,),
                onPressed: () async {
                  try {
                    Uri browserUri =
                        Uri(scheme: 'https', path: "play.google.com/");
                    await launchUrl(browserUri);
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                })
          ],
        )),
  );
}