import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:walidgpt/globals.dart';
import 'package:walidgpt/main.dart';
import 'login.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 100, 30, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Logo(),
                  SizedBox(
                    height: 50,
                  ),
                  SignupContainer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupContainer extends StatefulWidget {
  SignupContainer({super.key});
  static final double TEXTFIELDS_SPACE = 7;

  @override
  State<SignupContainer> createState() => _SignupContainerState();
}

class _SignupContainerState extends State<SignupContainer> {
  final emailController = TextEditingController();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final passwordController = TextEditingController();

  final passwordConfirmationController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  Future<String?> signup(String email, String firstName, String lastName,
    String password, String confirmationPassword) async {
  var url = Uri.parse('http://${server}:8000/users/signup/');
  final response = await post(url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'cpassword': confirmationPassword,
      }));
  Map data = json.decode(response.body);
  print(data['email']);
  return data['email'];
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
                prefixIcon: Icon(Icons.email),
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
              height: SignupContainer.TEXTFIELDS_SPACE,
            ),
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                hintText: 'First Name',
                isDense: true,
              ),
              validator: (value) {
                if (value == null || value!.isEmpty) {
                  return 'Please enter your first name';
                }
                return null; // Return null if the email is valid
              },
            ),
            SizedBox(
              height: SignupContainer.TEXTFIELDS_SPACE,
            ),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                isDense: true,
                hintText: 'Last Name',
              ),
              validator: (value) {
                if (value == null || value!.isEmpty) {
                  return 'Please enter your last name';
                }
                return null; // Return null if the email is valid
              },
            ),
            SizedBox(
              height: SignupContainer.TEXTFIELDS_SPACE,
            ),
            TextFormField(
              controller: passwordController,
              obscureText: _obscureText,
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
              height: SignupContainer.TEXTFIELDS_SPACE,
            ),
            TextFormField(
              controller: passwordConfirmationController,
              obscureText: _obscureText,
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
                hintText: 'Confirm Password',
              ),
              validator: (value) {
                if (value == null || value!.isEmpty) {
                  return 'Please enter your password';
                }
                if (value != passwordController.text) {
                  return 'Please enter the same password';
                }
                return null; // Return null if the email is valid
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Signup'),
              onPressed: () async {
                try {
                  if (_formKey.currentState!.validate()) {
                    String? email = await signup(
                        emailController.text.trim(),
                        firstNameController.text.trim(),
                        lastNameController.text.trim(),
                        passwordController.text.trim(),
                        passwordConfirmationController.text.trim());
                        print(email);
                    if (email != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  Login())));
                      emailController.clear();
                      firstNameController.clear();
                      lastNameController.clear();
                      passwordController.clear();
                      passwordConfirmationController.clear();
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
                          return errorMessage(
                              context, 'Email may be already used!!');
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
                    child: const Text("Login"),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                          (Route<dynamic> route) => false);
                    }),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: const Text("Contact Support"),
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
  dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }
}
