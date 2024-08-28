import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class serviceProfile extends StatefulWidget {
  serviceProfile({super.key, required this.userID});
  String userID;

  @override
  State<serviceProfile> createState() => _serviceProfileState();
}

class _serviceProfileState extends State<serviceProfile> {
  String firstName = '';
  String lastName = '';
  String mobile = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('dddddd${widget.userID}');
    getProfile(widget.userID);
  }

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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Card(
                  color: Color.fromARGB(255, 249, 227, 253),
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
                                  SizedBox(
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
              SizedBox(height: 20),
            ]),
          ),
        ));
  }

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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 40),
          Text(
            value.isEmpty ? 'N/A' : value,
            style: TextStyle(
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
      print('UserID is Empty');
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
          userId = data['userID'] ?? '';
        });
      } else {
        print('Document does not exist or data is null');
      }
    } catch (e) {
      print('Error fetching profil: $e');
    }
  }
}
