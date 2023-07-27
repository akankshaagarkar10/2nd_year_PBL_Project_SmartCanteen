import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pbl_studentend_clubbed/canteen_end.dart';
import 'package:pbl_studentend_clubbed/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final GlobalKey<FormState> _formKey = GlobalKey();

   String password = '';
    String email = '';

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: <Widget>[
          FlatButton(
            child: Row(
              children: const <Widget>[Text('Signup'), Icon(Icons.person_add)],
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(SignupScreen.routeName);
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.white,
                ],
              ),
            ),
          ),
          Center(
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  height: 280,
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            onChanged: (value) {
                              email = value;
                            },
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
                            decoration: const InputDecoration(
                              labelText: 'MIS ID',
                              hintText: 'E2K.........',
                            ),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              if (val!.length < 6) {
                                return "Password should have at least 6 character";
                              } else if (password == null || password == '') {
                                return "Please fill password above first";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              password = value;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                          ),

                          // const TextField(
                          //   decoration: InputDecoration(
                          //     labelText: 'User Category',
                          //     hintText: 'Canteen people or Student',
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 30,
                          // ),

                          ElevatedButton(
                            child: const Text('Login'),
                            onPressed: () async {

                              
                              try {
                                if (_formKey.currentState!.validate()) {
                                  final user =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                  if (user != null) {

                                    bool isAdmin = await FirebaseFirestore.instance.collection('Users').doc(user.user!.uid).get().then((value) => value.data()!['Role'])=='student'?false:true;
                                    
                                    if (isAdmin == false) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              TabsScreen.routeName);
                                    } else {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              CanteenEnd.routeName);
                                    }
                                  }
                                }
                              } catch (r) {
                                print(r);
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            color: Colors.blue,
                            textColor: Colors.white,
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
