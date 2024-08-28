import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/Login/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  String first = '';
  String last = '';
  String mobile = '';
  String password = '';
  String errorMessage = '';

  @override
  void dispose() {
    firstController.dispose();
    lastController.dispose();
    mobileController.dispose();
    passwordController.dispose();
  }

  double? height, width;

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
                    height: height! * .5,
                    decoration: const BoxDecoration(
                        // color: Colors.blue,
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.blue,
                              Color.fromARGB(255, 220, 137, 234)
                            ]),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/logo.jpeg'),
                              fit: BoxFit.cover)),
                    )
                    // const CircleAvatar(
                    //   child:
                    //   Icon(
                    //     Icons.home,
                    //     color: Colors.blue,
                    //     size: 40,
                    //   ),
                    //   radius: 50,
                    //   backgroundColor: Colors.white,
                    // ),
                    ),
                Container(
                  height: height! * .5,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Positioned(
                top: 20,
                left: 6,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ))),

            Positioned(
              bottom: 70,
              child: Card(
                elevation: 10,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.53,
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Center(
                            child: Text(
                          'SIGN UP',
                          style: TextStyle(
                              letterSpacing: 2,
                              fontSize: 20,
                              color: Color.fromARGB(255, 151, 64, 69)),
                        )),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: firstController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            hintText: 'Enter your first name ',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your first name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: lastController,
                          decoration: const InputDecoration(
                            labelText: 'Last name',
                            hintText: 'Enter your last name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          maxLength: 10,
                          controller: mobileController,
                          decoration: const InputDecoration(
                            labelText: 'Mobile number',
                            hintText: 'Enter you mobile number',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile no.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter you password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 151, 64, 69),
                ),
                height: 50,
                width: 200,
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 151, 64, 69)),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await storeUserData(
                            context,
                            firstController.text,
                            lastController.text,
                            mobileController.text,
                            passwordController.text);
                      }
                    },
                  ),
                ),
              ),
              // child: ElevatedButton(
              //   onPressed: () {},
              //   child: const Text('Login'),
              // ),
            ),
            // Positioned(
            //   bottom: 45,
            //   left: 30,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       TextButton(
            //           onPressed: () {},
            //           child: Text(
            //             'BACK TO LOGIN PAGE',
            //           )),
            //       // SizedBox(
            //       //   width: 110,
            //       // ),
            //       // TextButton(
            //       //     onPressed: () {},
            //       //     child: Text(
            //       //       'SIGN UP',
            //       //     ))
            //     ],
            //   ),
            // )
            SizedBox(
              height: 10,
            ),
            Positioned(
              bottom: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text(
                        'Already have an account? Sign In',
                        style: TextStyle(
                            color: Color.fromARGB(255, 151, 64, 69),
                            fontSize: 16),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Back to Login',
                        style: TextStyle(
                            color: Color.fromARGB(255, 151, 64, 69),
                            fontSize: 16),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> storeUserData(BuildContext context, String first, String last,
      String mobile, String password) async {
    String firstInitial = first[0][0].trim().toUpperCase();
    String lastInitial = last[0][0].trim().toUpperCase();
    String mobilelastFour = mobile.substring(mobile.length - 4);

    String userID = '$firstInitial$lastInitial$mobilelastFour';

    try {
      await firestore.collection('Usres').doc(userID).set({
        'First Name': first,
        'Last Name': last,
        'Mobile No': mobile,
        'Password': password,
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return LoginPage();
        }),
        (route) => false,
      );

      setState(() {
        errorMessage = '';
      });
    } on FirebaseException catch (e) {
      setState(() {
        errorMessage = e.message!;
      });
    }
  }
}
