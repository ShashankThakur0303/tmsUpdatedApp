import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ticket_management_system/Login/login.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController userIDController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Forgot Passowrd"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.09),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Card(
            elevation: 30,
            child: Form(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: userIDController,
                    decoration: InputDecoration(
                        labelText: 'UserID',
                        hintText: 'Enter your UserID',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your UserID';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 156, 106, 243)),
                    onPressed: () {
                      retrivePassword(userIDController.text, context);
                    },
                    child: const Text(
                      "Retrive Password",
                      style: TextStyle(fontSize: 18),
                    ))
              ],
            )),
          ),
        ),
      ),
    );
  }

  Future<void> retrivePassword(String userID, BuildContext context) async {
    try {
      final userDoc = await firestore.collection('members').doc(userID).get();
      if (userDoc.exists) {
        final password = userDoc.data()!['password'];
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Password Retrived'),
                content: Row(
                  children: [
                    const Text('Your Password is:  '),
                    Text(
                      '$password',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text("Back to Login"))
                ],
              );
            });
      } else {
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Center(
            child: Text('User does not exist'),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print('Error: $e');
      SnackBar snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Center(
            child: Text('An error occured. Please try again.'),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
