import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:walidgpt/main.dart';
import 'package:walidgpt/models/session.dart';
import '../globals.dart';

class HistroyPage extends StatefulWidget {
  HistroyPage({super.key});

  @override
  State<HistroyPage> createState() => _HistroyPageState();
}

class _HistroyPageState extends State<HistroyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: (!isDark)? lightTheme['background']: darkTheme['background'],
        backgroundColor: (!isDark)? lightTheme['background']: darkTheme['background'],
        iconTheme: IconThemeData(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
        centerTitle: true,
        title:
            Text((isArabic != true) ? 'Sessions': arabicLang['History']!, style: TextStyle(letterSpacing: 3, color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'])),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
      ),
      body: Container(decoration: BoxDecoration(color: (!isDark)? lightTheme['background']: darkTheme['background']), child: Sessions()),
    );
  }
}

class Sessions extends StatelessWidget {
  const Sessions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListSessions(),
    );
  }
}

class ListSessions extends StatefulWidget {
  const ListSessions({super.key});

  @override
  State<ListSessions> createState() => _ListSessionsState();
}

class _ListSessionsState extends State<ListSessions> {
  List<Session> sessions = [];

  @override
  void initState() {
    fetchSessions();
    super.initState();
  }

  void fetchSessions() async {
    var url = Uri.parse('http://${server}:8000/messengers/sessions/');
    final response = await get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${token}'
      },
    );
    print(response.body);
    List<dynamic> data = json.decode(response.body);
    print(data);
    setState(() {
      for (Map<String, dynamic> session in data) {
        sessions.add(Session.fromJson(session));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildMySessions(sessions);
  }

  Widget buildMySessions(List<Session> sessions) => ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final record = sessions[index];
          return InkWell(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.all(6),
                width: double.infinity,
                height: 65,
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 200, 200, 200)),
                  borderRadius: BorderRadius.circular(10),
                  color: (!isDark)? lightTheme['background']: darkTheme['background'],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${record.title}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${record.creationDate!.year}-${record.creationDate!.month}-${record.creationDate!.day}',
                              style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          child: Icon(Icons.remove, color: Colors.red),
                          onTap: () async {
                            var url = Uri.parse(
                                'http://${server}:8000/messengers/delete_session/${record.id}/');
                            final response = await delete(url,
                                headers: {
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': 'Token ${token}'
                                },
                                body: jsonEncode({
                                  "id": record.id,
                                }));
                            print(response.body);
                            if (response.statusCode == 200) {
                              setState(() {
                                sessions.remove(record);
                              });
                            }
                          },
                        ),
                        SizedBox(width: 6)
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: ((context) => MessagePage(session: record.id))),
                    (route) => false);
              }
              ,);
        },
      );
}