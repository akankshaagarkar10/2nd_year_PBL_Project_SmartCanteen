import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignupScreen({Key? key}) : super(key: key);
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late bool changed;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String email = '';
  String username = '';
  String password = '';
  String confirm_password = '';

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Login ',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue,
                Colors.white,
              ]),
            ),
          ),
          Center(
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  height: 400,
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.name,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter your name';
                              }
                            },
                            onChanged: (value) {
                              username = value;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val!.length < 5) {
                                return "MIS ID is too short";
                              } else if (!val.endsWith("@ms.pict.edu")) {
                                return "MIS ID is not correct";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              email = value;
                            },
                            decoration:
                                const InputDecoration(labelText: 'MIS ID'),
                          ),
                          TextFormField(
                            obscureText: true,
                            onChanged: (value) {
                              password = value;
                            },
                            validator: (value) {
                              RegExp regex = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              if (value!.isEmpty) {
                                return 'Please enter password';
                              } else {
                                if (!regex.hasMatch(value)) {
                                  return 'Enter valid password';
                                } else {
                                  return null;
                                }
                              }
                            },
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                          ),
                          TextFormField(
                            obscureText: true,
                            onChanged: (value) {
                              confirm_password = value;
                            },
                            validator: (val) {
                              if (val!.length <= 6) {
                                return "Password should have at least 6 character";
                              } else if (password == null || password == '') {
                                return "Please fill password above first";
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                                labelText: 'Confirm Password'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                children: <Widget>[
                                  const SizedBox(height: 30),
                                  RaisedButton(
                                    child: const Text('student'),
                                    onPressed: () {
                                      changed = false;
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                  ),
                                  const SizedBox(height: 30),
                                  RaisedButton(
                                    child: const Text('admin'),
                                    onPressed: () {
                                      changed = true;
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            child: const Text(
                              'Submit',
                            ),
                            onPressed: () async {
                              print(
                                  '$email $username $password $confirm_password');
                              try {
                                if (password != confirm_password) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please re-enter the above password first")));
                                } else if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  final user = await _auth
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password);
                                  if (user != null) {
                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid
                                            .toString())
                                        .set({
                                      'Name':
                                          username, //replace with own name from TextField
                                      'Role': changed ? 'admin' : 'student',
                                    });

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  }
                                }
                              } catch (e) {
                                print("Error while signIN > $e");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
