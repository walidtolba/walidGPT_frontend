import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walidgpt/globals.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: (!isDark)? lightTheme['background']: darkTheme['background'],
        surfaceTintColor: (!isDark)? lightTheme['background']: darkTheme['background'],
        iconTheme: IconThemeData(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
        centerTitle: true,
        title:
            Text((isArabic != true) ? 'Settings': arabicLang['Settings']!, style: TextStyle(letterSpacing: 3, color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: (!isDark)? lightTheme['background']: darkTheme['background']),
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [

            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  (isArabic != true) ? 'Adjest settings': arabicLang['Adjest settings']!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
                  textDirection: (isArabic != true) ? TextDirection.ltr: TextDirection.rtl,
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
              color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          (isArabic != true) ? 'Offline Model': arabicLang['Offline Model']!,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isOffline,
              onChanged: (bool val) {
                isOffline = !isOffline;
                setState(() {
                  
                });
              },
            ))
      ],
    ),Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          (isArabic != true) ? 'Speaker': arabicLang['Speaker']!,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isSpeaker,
              onChanged: (bool val) {
                isSpeaker = !isSpeaker;
                setState(() {
                  
                });
              },
            ))
      ],
    ),Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          (isArabic != true) ? 'Arabic': arabicLang['Arabic']!,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isArabic,
              onChanged: (bool val) {isArabic = !isArabic;
                setState(() {
                  
                });},
            ))
      ],
    ),Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          (isArabic != true) ? 'Dark Mode': arabicLang['Dark Mode']!,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isDark,
              onChanged: (bool val) {isDark = !isDark;
                setState(() {
                  
                });},
            ))
      ],
    )
          ],
        ),
      ),
    );
  }

}