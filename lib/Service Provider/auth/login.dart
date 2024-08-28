// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class LoginService extends StatefulWidget {
//   const LoginService({super.key});

//   @override
//   State<LoginService> createState() => _LoginServiceState();
// }

// class _LoginServiceState extends State<LoginService> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController emailcontroller = TextEditingController();
//   TextEditingController passwordcontroller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//         body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircleAvatar(
//             radius: 80,
//             backgroundImage: AssetImage('assets/service.png'),
//             backgroundColor: Colors.white,
//           ),
//           const SizedBox(
//             height: 40,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'C.M.S',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         textInputAction: TextInputAction.next,
//                         controller: emailcontroller,
//                         decoration: InputDecoration(
//                             enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                                 borderSide:
//                                     const BorderSide(color: Colors.red)),
//                             labelText: 'Email',
//                             labelStyle: const TextStyle(color: Colors.black),
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 borderSide:
//                                     const BorderSide(color: Colors.grey)),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(40),
//                                 borderSide:
//                                     const BorderSide(color: Colors.green))),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter email ID';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       TextFormField(
//                         textInputAction: TextInputAction.next,
//                         controller: passwordcontroller,
//                         obscureText: true,
//                         decoration: const InputDecoration(
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.black),
//                             ),
//                             labelText: 'Password',
//                             labelStyle: TextStyle(
//                               color: Colors.black,
//                             )),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter password';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       ElevatedButton(
//                           onPressed: () {
//                             // if (_formKey.currentState!.validate()) {
//                             //   login(emailcontroller.text,
//                             //       passwordcontroller.text, context);
//                             // }
//                           },
//                           child: Text('Login'))
//                     ],
//                   )),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 children: [
//                   TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Don't have an account ?",
//                         style: TextStyle(fontSize: 18),
//                       )),
//                   TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Sign-Up",
//                         style: TextStyle(fontSize: 18),
//                       ))
//                 ],
//               )
//             ],
//           ),
//         ],
//       ),
//     ));
//   }
// }
