import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:walidgpt/about.dart';
import 'package:walidgpt/history.dart';
import 'package:walidgpt/login.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:walidgpt/models/message.dart';
import 'package:walidgpt/globals.dart';
import 'package:walidgpt/models/user.dart';
import 'package:walidgpt/settings.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
enum TtsState { playing, stopped, paused, continued }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WalidGPT',
      theme: ThemeData(
          colorScheme: ColorScheme.light(),
          useMaterial3: true,
          appBarTheme: AppBarTheme(elevation: 0)),
      home: const Login(),
    );
  }
}

class MessagePage extends StatefulWidget {
  int? session;
  MessagePage({super.key, this.session});
  @override
  State<MessagePage> createState() => _MessagePageState(session);
}

class _MessagePageState extends State<MessagePage> {
  int? session;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  final TextEditingController _controller = TextEditingController();
  List<Message> messages = [];
  Color buttonColor = Color.fromARGB(255, 200, 200, 200);
  late FlutterTts flutterTts;
  String? _newVoiceText;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  _MessagePageState(this.session);
  @override
  void initState() {
    fetchMessages();
    initSession();
    super.initState();
    _initSpeech();
    _initTts();
  }

  _initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.speak(_newVoiceText!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }
  

  void initSession() async {
    session ??= await createSession();
    print(session);
  }

  void fetchMessages() async {
    var url =
        Uri.parse('http://${server}:8000/messengers/list_messages/${session}/');
    final response = await get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${token}'
      },
    );
    print(response.body);
    List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      for (Map<String, dynamic> message in data) {
        messages.add(Message.fromJson(message));
      }
    });
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult, localeId: (!isArabic)? 'en-US': 'ar');
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _controller.text = _lastWords;
      buttonColor = Colors.blue[100]!;
    });
  }

  Future<Message> createMessage() async {
    var url = Uri.parse('http://${server}:8000/messengers/create_messages/');
    final response = await post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${token}'
        },
        body: json.encode({
          'session': session,
          'sender': myProfile.id,
          'content': _controller.text.trim(),
          'offline': isOffline,
          'arabic': isArabic,
        }));
    _controller.text = '';

    Map data = json.decode(utf8.decode(response.bodyBytes));
    Message message = Message.fromJson(data);
    return message;
  }

  Future<int?> createSession() async {
    var url = Uri.parse('http://${server}:8000/messengers/sessions/');
    final response = await post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${token}'
        },
        body: json.encode({}));
    _controller.text = '';

    Map data = json.decode(response.body);
    int id = data['id'];
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: (!isDark) ? lightTheme['foreground']: darkTheme['foreground']),
        surfaceTintColor: (!isDark) ? lightTheme['background']: darkTheme['background'],
        backgroundColor: (!isDark) ? lightTheme['background']: darkTheme['background'],
        title: Text('New Chat', style: TextStyle(color: (!isDark) ? lightTheme['foreground']: darkTheme['foreground'],),),
        actions: [
          IconButton(
              onPressed: () async {
                session = await createSession();
                setState(() {
                  messages = [];
                });
              },
              icon: Icon(Icons.add),),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
      ),
      drawer: Drawer(
      
        backgroundColor: (!isDark)? lightTheme['background']: darkTheme['background'],
        elevation: 0,
        width: MediaQuery.of(context).size.width * 0.9,
        child: ListView(

          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                '${myProfile.firstName} ${myProfile.lastName}',
                style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
              ),
              accountEmail: Text(
                '${myProfile.email}',
                style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'],),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.lightGreen,
                child: ClipOval(
                    child: Text(
                        '${myProfile.firstName![0]}${myProfile.lastName![0]}'
                            .toUpperCase(),
                        style: TextStyle(fontSize: 20,))),
              ),
              decoration: BoxDecoration(
                color: (!isDark)? lightTheme['background']: darkTheme['background'],
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/profile_background.jpg')),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.add,
                color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'],
              ),
              title: Text(
                (isArabic != true) ? 'New Chat': arabicLang['New Chat']!,
                style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
              ),
              onTap: () async {
                session = await createSession();
                setState(() {
                  messages = [];
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.history,
                color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'],
              ),
              title: Text(
                (isArabic != true) ? 'History': arabicLang['History']!,
                style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => HistroyPage())));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'],
              ),
              title: Text(
                (isArabic != true) ? 'Settings': arabicLang['Settings']!,
                style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
              ),
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => SettingsPage())));
                    setState(() {
                      
                    });
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'],
              ),
              title: Text(
                (isArabic != true) ? 'Logout': arabicLang['Logout']!,
                style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
              ),
              onTap: () {
                token = '';
                myProfile = User();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: ((context) => Login())),
                    (route) => false);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: (!isDark)? lightTheme['foreground']: darkTheme['foreground'],
              ),
              title: Text(
                (isArabic != true) ? 'About': arabicLang['About']!,
                style: TextStyle(color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      if (!isArabic)
                      return showAbout(context);
                      return showAboutArabic(context);
                    });
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: (!isDark) ? lightTheme['background']: darkTheme['background']),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  height: MediaQuery.of(context).size.height -
                      125 -
                      MediaQuery.of(context).viewInsets.bottom -
                      AppBar().preferredSize.height,
                  child: buildMessages(messages)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.85,
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: TextField(
                          textDirection: (isArabic != true) ? TextDirection.ltr: TextDirection.rtl,
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: (isArabic != true) ? 'Message': arabicLang['Message']!,
                            filled: true,
                            fillColor: Colors.blue.shade50,
                            labelStyle: TextStyle(fontSize: 12),
                            contentPadding: EdgeInsets.all(20),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue.shade50),
                                borderRadius: BorderRadius.circular(50)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue.shade50),
                                borderRadius: BorderRadius.circular(50)),
                            prefixIcon: IconButton(
                              icon: Icon(_speechToText.isNotListening
                                  ? Icons.mic_off
                                  : Icons.mic),
                              onPressed: _speechToText.isNotListening
                                  ? _startListening
                                  : _stopListening,
                            ),
                          ),
                          onChanged: (text) {
                            if (text == ''){
                            if (buttonColor == Colors.blue[100]!)
                              setState(() {
                                buttonColor = Color.fromARGB(255, 200, 200, 200);
                              });}
                            else if (buttonColor == Color.fromARGB(255, 200, 200, 200))
                              setState(() {
                                buttonColor = Colors.blue[100]!;
                              });
                            
                          
                          },
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: buttonColor),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_upward,
                            color: Colors.black45,
                          ),
                          onPressed: () async {
                            setState(
                              () {
                                messages.add(Message(
                                    sender: 'patient',
                                    content: _controller.text.trim()));
                              },
                            );
                            
                            Message message = await createMessage();
                            setState(
                              () {
                                messages.add(message);
                                buttonColor = Color.fromARGB(255, 200, 200, 200);
                              },
                            );
                            _newVoiceText = message.content;
                            if (isSpeaker)
                              await _speak();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessages(List<Message> messages) => ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          print(message.content);
          return Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                message.sender == 'patient'
                    ? CircleAvatar(
                        backgroundColor: Colors.lightGreen,
                        radius: 13,
                        child: Text(
                          'WR',
                          style: TextStyle(fontSize: 10),
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.lightGreen,
                        radius: 13,
                        child: ClipOval(
                            child: Image.asset('assets/images/logo.jpg')),
                      ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      (message.sender == 'patient' ? '${myProfile.firstName} ${myProfile.lastName}' : 'Chat Bot')
                          .toUpperCase(),
                      style: TextStyle(fontSize: 12, color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        message.content!,
                        style: TextStyle(fontSize: 16, color: (!isDark)? lightTheme['foreground']: darkTheme['foreground']),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      );
}
