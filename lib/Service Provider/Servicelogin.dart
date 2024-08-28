import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_management_system/Login/login.dart';
import 'package:ticket_management_system/Service%20Provider/Servicesignup.dart';
import 'package:ticket_management_system/Service%20Provider/service_home.dart';

class LoginService extends StatefulWidget {
  const LoginService({super.key});

  @override
  State<LoginService> createState() => _LoginServiceState();
}

class _LoginServiceState extends State<LoginService> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController serviceIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  double? height, width;

  @override
  void dispose() {
    super.dispose();
    serviceIDController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 110),
            child: const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/service.png'),
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            'T.M.S',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: serviceIDController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: 'Username',
                        hintText: 'Enter your username',
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter UserID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login(serviceIDController.text,
                                passwordController.text, context);
                          }
                        },
                        child: const Text('Login'))
                  ],
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TextButton(
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const serviceSignup()));
              //     },
              //     child: const Text(
              //       "Don't have an account ? Sign-Up",
              //       style: TextStyle(fontSize: 15),
              //     )),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('Back to users'),
              )
            ],
          ),
        ],
      ),
    ));
  }

  void storeServiceLogin(bool isLogin, String serviceID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('serviceID');
    prefs.setBool('isLogin', isLogin);
    prefs.setString('serviceID', serviceID);
  }

  Future login(
      String serviceID, String servicePassword, BuildContext context) async {
    try {
      final serviceDoc = await FirebaseFirestore.instance
          .collection('ServiceProviders')
          .doc(serviceID)
          .get();

      if (serviceDoc.exists) {
        final storedPassword = serviceDoc.data()!['password'];
        print('shashank' + storedPassword);
        if (servicePassword.trim() == storedPassword.toString().trim()) {
          storeServiceLogin(true, serviceIDController.text);
          SnackBar snackBar = const SnackBar(
              backgroundColor: Colors.green,
              content: Center(
                child: Text('Login successful'),
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>  Homeservice(userID: '',)),
              (route) => false);
        } else {
          SnackBar snackBar = const SnackBar(
              backgroundColor: Colors.red,
              content: Center(
                child: Text('Incorrect Password'),
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        SnackBar snackBar = const SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text('User does not exist'),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
