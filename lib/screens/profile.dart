import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/screens/resetpassword.dart';

class profile extends StatefulWidget {
  profile({required this.userID, Key? key}) : super(key: key);
  String userID;

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  void initState() {
    getProfile(widget.userID);
    // TODO: implement initState
    super.initState();
  }

  String firstName = '';
  String lastName = '';
  String mobile = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 141, 36, 41),
          title: const Text('Profile'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Card(
                    color: const Color.fromARGB(255, 249, 227, 253),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buidProfileItem('First Name', firstName),
                                    // Text(
                                    //   'First Name: $firstName',
                                    //   style: TextStyle(
                                    //       fontSize: 16, color: Colors.black),
                                    // ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    buidProfileItem('Last Name', lastName),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    buidProfileItem('Mobile', mobile),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    buidProfileItem('User ID', widget.userID)
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 15,
                        shadowColor: Color.fromARGB(255, 141, 36, 41),
                        backgroundColor: Color.fromARGB(255, 141, 36, 41),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => resetPassword(
                                    userID: widget.userID,
                                  )));
                    },
                    child: const Text(
                      'Change Password',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
              ],
            ),
          ),
        ));
  }

  // Widget buildTextField(
  //     String labelText, String placeholder, bool isPasswordTextField) {
  //   return Padding(
  //     padding: EdgeInsets.only(bottom: 30),
  //     child: TextField(
  //       decoration: InputDecoration(
  //           suffixIcon: isPasswordTextField
  //               ? IconButton(
  //                   onPressed: () {},
  //                   icon: Icon(
  //                     Icons.remove_red_eye,
  //                     color: Colors.grey,
  //                   ))
  //               : null,
  //           contentPadding: EdgeInsets.only(bottom: 5),
  //           labelText: labelText,
  //           floatingLabelBehavior: FloatingLabelBehavior.always,
  //           hintText: placeholder,
  //           hintStyle: TextStyle(
  //               fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
  //     ),
  //   );
  // }

  Widget buidProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.30,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 141, 36, 41),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Center(
                  child: Text(
                    "$label:",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
          Text(
            value.isEmpty ? 'N/A' : value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Future<void> getProfile(String userId) async {
    if (userId.isEmpty) {
      print('User ID is empty');
      return;
    }
    try {
      DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('members')
          .doc(userId)
          .get();
      if (querySnapshot.exists && querySnapshot.data() != null) {
        Map<String, dynamic> data =
            querySnapshot.data() as Map<String, dynamic>;
        setState(() {
          firstName = data['fName'] ?? '';
          lastName = data['lName'] ?? '';
          mobile = data['mobile'] ?? '';
          userId = data['userId'] ?? '';
        });
      } else {
        print('Document does not exist or data is null');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }
}
