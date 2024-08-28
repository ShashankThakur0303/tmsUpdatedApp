import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class pendingstatus extends StatefulWidget {
  final String Number;
  pendingstatus({Key? key, required this.Number}) : super(key: key);

  @override
  State<pendingstatus> createState() => _pendingstatusState();
}

class _pendingstatusState extends State<pendingstatus> {
  String work = '';
  String building = '';
  String floor = '';
  String room = '';
  String asset = '';
  String remark = '';
  String serviceprovider = '';
  //List<String> imageFilePaths = [];

  String? _selectedServiceProvider;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTicketData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Ticket ${widget.Number}'),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : 
          SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Ticket ${widget.Number}',
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.work,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              'Work: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("${work}")
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.business,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "Building: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('${building}')
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.layers,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              'Floor: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('${floor}')
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.room,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              'Room: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('${room}'),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.account_balance,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "Asset: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('${asset}')
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          Icon(Icons.comment, color: Colors.deepPurple),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Remark: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('${remark}')
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.build,
                              color: Colors.deepPurple,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'ServiceProvider:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("${serviceprovider}"),
                          ],
                        )

                        // customCard('Work', work, Icons.work),
                        // customCard('Building', building, Icons.business),
                        // customCard('Floor', floor, Icons.layers),
                        // customCard('Room', room, Icons.room),
                        // customCard('Asset', asset, Icons.account_balance),
                        // customCard('Remark', remark, Icons.comment),
                        // customCard(
                        //     'Serviceprovider', serviceprovider, Icons.build),
                        // imageFilePaths.isNotEmpty
                        //     ? displayImages()
                        //     : Container(
                        //         // color: Colors.red,
                        //         // height: MediaQuery.of(context).size.height * 0.9,
                        //         // width: MediaQuery.of(context).size.width * 0.8,
                        //         ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // Widget customCard(String title, String message,
  // IconData icon) {
  //   return Card(
  //     margin: const EdgeInsets.symmetric(vertical: 10.0),
  //     elevation: 3,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //     child: ListTile(
  //       leading: Icon(icon, color: Colors.deepPurple),
  //       title: Text(
  //         title,
  //         style: const TextStyle(
  //           fontWeight: FontWeight.bold,
  //           fontSize: 15,
  //         ),
  //       ),
  //       subtitle: Text(
  //         message,
  //         style: const TextStyle(fontSize: 14),
  //       ),
  //     ),
  //   );
  // }

  // Widget displayImages() {
  //   return Column(
  //     children: imageFilePaths.map((path) {
  //       // return Padding(
  //       //     padding: EdgeInsets.symmetric(vertical: 8.0),
  //       //     child: Image.file(File(path)));
  //       return FutureBuilder<File>(
  //           future: _getImageFile(path),
  //           builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
  //             if (snapshot.connectionState == ConnectionState.done) {
  //               if (snapshot.hasError) {
  //                 return Text('Error: ${snapshot.error}');
  //               } else if (snapshot.hasData) {
  //                 return Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 8.0),
  //                   child: Image.file(snapshot.data!),
  //                 );
  //               } else {
  //                 return const Text('File not found');
  //               }
  //             } else {
  //               return const CircularProgressIndicator();
  //             }
  //           });
  //     }).toList(),
  //   );
  // }

  // Future<File> _getImageFile(String path) async {
  //   return File(path);
  // }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}';
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  Future<void> getTicketData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('raisedTickets')
        .doc(widget.Number)
        .get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> mapData =
          documentSnapshot.data() as Map<String, dynamic>;
      asset = mapData['asset'];
      building = mapData['building'];
      floor = mapData['floor'];
      remark = mapData['remark'];
      room = mapData['room'];
      work = mapData['work'];
      serviceprovider = mapData['serviceProvider'] ?? "";
      //imageFilePaths = List<String>.from(mapData['imageFilePaths']);
      setState(() {
        loading = false;
      });
    }
  }
}
