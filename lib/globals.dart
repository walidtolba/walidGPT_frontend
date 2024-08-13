import 'package:flutter/material.dart';
import 'package:walidgpt/models/user.dart';

var server = '192.168.148.166';
var token = '';
var myProfile = User();
bool isOffline = false;
bool isSpeaker = false;
bool isArabic = false;
bool isDark = false;

Widget errorMessage(BuildContext context, String message) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
        height: 150,
        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          children: [
            Text(
              'ERROR',
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Text(message),
          ],
        )),
  );
}

const arabicLang = {
  'New Chat': 'محادثة جديدة',
  'History': 'المحادثات السابقة',
  'Settings': 'الاعدادات',
  'Logout': 'تسجيل الخروج',
  'About': 'حول التطبيق',
  'Message': 'الرسالة',
  'Adjest settings': 'ضبط الإعدادات',
  'Offline Model': 'غير متصل',
  'Speaker': 'مكبر الصوت',
  'Arabic': 'عربي',
  'Dark Mode': 'الوضع المظلم',

};

const darkTheme = {
  'background': Colors.black87,
  'foreground': Colors.white
};

const lightTheme = {
  'background': Colors.white,
  'foreground': Colors.black

};