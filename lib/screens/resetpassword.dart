import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class resetPassword extends StatefulWidget {
  resetPassword({super.key, required this.userID});
  String userID;
  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  Future<void> _changePassword(
      String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      // Reauthenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!, password: currentPassword);
      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password successfully changed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change password: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
          backgroundColor: Color.fromARGB(255, 141, 36, 41),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.password,
                    size: 80,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    height: 250,
                    width: 500,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _currentPasswordController,
                              decoration: const InputDecoration(
                                  labelText: 'Current Password',
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue))),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your current password';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _newPasswordController,
                              decoration: const InputDecoration(
                                  labelText: 'New Password',
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue))),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a new password';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 141, 36, 41),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _changePassword(
                                  _currentPasswordController.text,
                                  _newPasswordController.text,
                                );
                              }
                            },
                            child: const Text('Change Password'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> updatePassword(
      String oldPassword, String newPassword, String userID) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    DocumentSnapshot user = await instance.collection('Usres').doc().get();
    if (user.exists) {
      if (oldPassword == user['Password']) {
        await instance
            .collection('Usres')
            .doc()
            .update({'Password': newPassword});
        Navigator.pop(context);
        SnackBar snackBar = SnackBar(
          content: Center(
            child: Text('Password Updated Successfully'),
          ),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        SnackBar snackBar = SnackBar(
          content: Center(
            child: Text('Invalid Old Password'),
          ),
          backgroundColor: Colors.red,
        );
      }
    } else {
      SnackBar snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Center(
            child: Text('Invalid User Id'),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

// class password extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => resetPassword()));
//             },
//             child: const Text('Changed Password')),
//       ),
//     );
//   }
// }
