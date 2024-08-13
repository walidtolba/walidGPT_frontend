import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:walidgpt/globals.dart';
import 'package:walidgpt/main.dart';
import 'package:walidgpt/models/user.dart';
import 'signup.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Logo(),
                SizedBox(
                  height: 50,
                ),
                LoginContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginContainer extends StatefulWidget {
  LoginContainer({super.key});
  static final double TEXTFIELDS_SPACE = 7;

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  Future<String?> login(String email, String password) async {
  var url = Uri.parse('http://${server}:8000/users/login/');
  final response = await post(url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }));
  Map data = json.decode(response.body);
  return data['token'];
}

Future<void> fetchMyProfile() async {
  var url = Uri.parse('http://${server}:8000/users/my_profile/');
  final response = await get(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token ${token}'
    },
  );
  Map<String, dynamic> data = json.decode(response.body);
  myProfile = User.fromJson(data);
}

  @override
  build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                hintText: 'Email',
                isDense: true,
              ),
              validator: (value) {
                if (value == null || value!.isEmpty) {
                  return 'Please enter an email address';
                }
                bool isValid = RegExp(
                        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$')
                    .hasMatch(value!);
                if (!isValid) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(
              height: LoginContainer.TEXTFIELDS_SPACE,
            ),
            TextFormField(
              obscureText: _obscureText,
              controller: passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                suffixIcon: InkWell(
                  child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off),
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                border: OutlineInputBorder(),
                isDense: true,
                hintText: 'Password',
              ),
              validator: (value) {
                if (value == null || value!.isEmpty) {
                  return 'Please enter your password';
                }
                return null; // Return null if the email is valid
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () async {
                 try {
                  if (_formKey.currentState!.validate()) {
                    token = (await login(emailController.text.trim(),
                        passwordController.text.trim()))!;
                    if (token != null) {
                        await fetchMyProfile();
                        print('this happend');
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    MessagePage())));

                      passwordController.clear();
                    }
                  }
                } catch (e) {
                  print('${e.runtimeType}');
                  if (e is ClientException) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return errorMessage(
                              context, 'There is no connection!!');
                        });
                  } else if (e is TimeoutException) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return errorMessage(
                              context, 'Timeout Error, try again!!');
                        });
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return errorMessage(context,
                              'Invalid Email or Password, try again!!');
                        });
                  }
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                InkWell(
                  child: Text("Signup"),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: Text("Contact Support"),
                  onTap: () {
                    
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  disopose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});
  @override
  build(BuildContext context) {
    return Container(
      child: ClipOval(child: Image.asset('assets/images/logo.jpg')),
      width: MediaQuery.of(context).size.width * 0.5,
    );
  }
}























