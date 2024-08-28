import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_management_system/Homescreen.dart';
import 'package:ticket_management_system/Login/forgot.dart';
import 'package:ticket_management_system/Login/sign-up.dart';
import 'package:ticket_management_system/Service%20Provider/Servicelogin.dart';
import 'package:ticket_management_system/screens/split_Screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController userIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  double? height, width;

  @override
  void dispose() {
    super.dispose();
    userIDController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    height: height! * .4,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/logo.jpeg'),
                              fit: BoxFit.cover)),
                    )),
                Container(
                  height: height! * .6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.2,
              child: Card(
                elevation: 10,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // const Center(
                        //     child: Text(
                        //   'LOGIN',
                        //   style: TextStyle(
                        //       letterSpacing: 2,
                        //       fontSize: 20,
                        //       color: Color.fromARGB(255, 151, 64, 69)),
                        // )),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: userIDController,
                          decoration: const InputDecoration(
                              labelText: 'Username',
                              hintText: 'Enter you username',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 151, 64, 69)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your UserID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter you password',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 151, 64, 69)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 151, 64, 69),
                ),
                height: 50,
                width: 200,
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 151, 64, 69)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await login(userIDController.text.trim(),
                            passwordController.text, context);
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              // child: ElevatedButton(
              //   onPressed: () {},
              //   child: const Text('Login'),
              // ),
            ),
            Positioned(
                bottom: 5,
                right: 20,
                child:

                    // TextButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => const LoginService()));
                    //     },
                    //     child: const Text(
                    //       'Login as Service Provider',
                    //       style:
                    //           TextStyle(color: Color.fromARGB(255, 151, 64, 69)),
                    //     )),
                    // const SizedBox(
                    //   width: 60,
                    // ),
                    TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SignupPage()));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ForgetPasswordScreen()));
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 151, 64, 69)),
                        )))
          ],
        ),
      ),
    );
  }

  void storeLoginData(bool isLogin, String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userID');
    prefs.setBool('isLogin', isLogin);
    prefs.setString('userID', userID);
  }

  Future<void> login(
      String userID, String password, BuildContext context) async {
    try {
      QuerySnapshot userDoc =
          await FirebaseFirestore.instance.collection('members').get();

      List<QueryDocumentSnapshot> documents = userDoc.docs;

      for (var doc in documents) {
        print(doc['userId']);

        if (doc['userId'] == userID) {
          final storedPassword = doc['password'];
          // userDoc.data()!['password'];
          print(storedPassword);
          if (password == storedPassword) {
            storeLoginData(true, userIDController.text);
            SnackBar snackBar = const SnackBar(
                backgroundColor: Colors.green,
                content: Center(
                  child: Text('Login successful'),
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        //  HomeScreen(
                        //       userID: userIDController.text,
                        //     )
                        spliScreen(
                          userID: userID,
                        )),
                (route) => false);
          } else {
            SnackBar snackBar = const SnackBar(
                backgroundColor: Colors.red,
                content: Center(
                  child: Text('Incorrect Password'),
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
        // else {
        //   SnackBar snackBar = const SnackBar(
        //       backgroundColor: Colors.red,
        //       content: Center(
        //         child: Text('User does not exist'),
        //       ));
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // }
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
