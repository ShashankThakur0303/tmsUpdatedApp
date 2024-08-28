import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ticket_management_system/Homescreen.dart';
import 'package:ticket_management_system/screens/image.dart';

class Raise extends StatefulWidget {
  Raise({super.key, required this.userID});
  String userID;

  @override
  State<Raise> createState() => _RaiseState();
}

class _RaiseState extends State<Raise> {
  final workController = TextEditingController();
  final buildingController = TextEditingController();
  final floorController = TextEditingController();
  final roomController = TextEditingController();
  final assetController = TextEditingController();
  final remarkController = TextEditingController();

  String serviceProviders = 'N/A';
  List<String> workOptions = [];
  List<String> buildingOptions = [];
  List<String> floorOptions = [];
  List<String> roomOptions = [];
  List<String> assetOptions = [];
  //List<String> serviceOptions = [];

  String? selectedServiceProvider;
  String? _selectedWork;
  String? _selectedBuilding;
  String? _selectedFloor;
  String? _selectedRoom;
  String? _selectedAsset;
  String ticketID = '';
  String? selectedBuildingNo = '';
  String? selectedFloorNo = '';
  List<Asset> images = <Asset>[];
  final _formKey = GlobalKey<FormState>();
  FilePickerResult? result;
  List<String>? Imagenames = [];
  XFile? file;
  List<File>? filepath = [];

  @override
  void initState() {
    getBuilding().whenComplete(() {
      getFloor().whenComplete(() {
        getRoom().whenComplete(() {
          getAsset().whenComplete(() {
            setState(() {});
          });
        });
      });
    });
    super.initState();
    getWork();
    // fetchServiceProvider();
    //getService();
  }

  @override
  void dispose() {
    workController.dispose();
    buildingController.dispose();
    floorController.dispose();
    roomController.dispose();
    assetController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Raise Ticket',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              _getCurrentDate(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 141, 36, 41),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLandscape = constraints.maxWidth > constraints.maxHeight;
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 3,
                          margin: const EdgeInsets.all(4.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: DropdownButtonFormField(
                                    value: _selectedWork,
                                    items: workOptions.map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedWork = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Work',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: DropdownButtonFormField(
                                    value: _selectedBuilding,
                                    items: buildingOptions.map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList(),
                                    onChanged: (value) async {
                                      floorOptions.clear();
                                      selectedBuildingNo = value;

                                      setState(() {
                                        _selectedBuilding = value;
                                        getFloor();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Building',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: DropdownButtonFormField(
                                    value: _selectedFloor,
                                    items: floorOptions.map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList(),
                                    onChanged: (value) async {
                                      selectedFloorNo = value;
                                      setState(() {
                                        _selectedFloor = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Floor',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: DropdownButtonFormField(
                                    value: _selectedRoom,
                                    items: roomOptions.map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList(),
                                    onChanged: (value) async {
                                      roomOptions.clear;

                                      setState(() {
                                        _selectedRoom = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Room',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: DropdownButtonFormField(
                                    value: _selectedAsset,
                                    items: assetOptions.map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAsset = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Asset',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextField(
                                    maxLength: 30,
                                    controller: remarkController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: 'Remarks',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: constraints.maxHeight / 3,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (Imagenames != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Text(
                                    'Selected file:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 500,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: Imagenames!.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageScreen(
                                                          pageTitle:
                                                              'raisePage',
                                                          imageFile:
                                                              Imagenames![
                                                                  index],
                                                          imageFiles:
                                                              Imagenames!,
                                                          initialIndex: index,
                                                          ticketId: ticketID,
                                                        )));
                                          },
                                          child: Center(
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Image.file(
                                                  File(Imagenames![index])),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 141, 36, 41)),
                                  onPressed: () async {
                                    result = await FilePicker.platform
                                        .pickFiles(
                                            withData: true,
                                            type: FileType.any,
                                            allowMultiple: true);
                                    if (result == null) {
                                      print('No file selected');
                                    } else {
                                      result?.files.forEach((element) {
                                        print(element.name);

                                        Imagenames!
                                            .add(element.path.toString());
                                        var filedata =
                                            File(element.path.toString());
                                        filepath!.add(filedata);
                                      });
                                      setState(() {});
                                    }
                                  },
                                  child: const Text('Pick Images')),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 141, 36, 41)),
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  file = await picker.pickImage(
                                      source: ImageSource.camera);

                                  if (file != null) {
                                    setState(() {
                                      Imagenames!.add(file!.path);
                                      var filedata = File(file!.path);
                                      filepath!.add(filedata);
                                      //  filepath = File(Imagenames[0]);
                                    });
                                  }
                                },
                                child: const Text('Capture Images')),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 141, 36, 41),
                                ),
                                onPressed: () async {
                                  popupmessage(
                                      "Your ticket is being raised, please wait...");
                                  await generateTicketID();
                                  fetchServiceProvider().whenComplete(() {
                                    if (_formKey.currentState!.validate()) {
                                      storeRaisedTicket(ticketID)
                                          .whenComplete(() async {
                                        await uploadFile(ticketID);
                                      });
                                    }
                                  });
                                },
                                child: const Text('Save'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}';
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  Future<String> generateTicketID() async {
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    int currentYear = DateTime.now().year;

    String currentMonth = DateFormat('MMM').format(DateTime.now());

    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection("raisedTickets")
        // .doc(currentYear.toString())
        // .collection('months')
        // .doc(currentMonth.toString())
        // .collection('date')
        .doc(date)
        .collection('tickets')
        .get();

    int lastTicketID = 1;
    if (doc.docs.isNotEmpty) {
      lastTicketID = doc.docs.length + 1;
    }

    DateTime now = DateTime.now();

    String formattedDate = "${now.year.toString().padLeft(4, '0')}"
        "${now.month.toString().padLeft(2, '0')}"
        "${now.day.toString().padLeft(2, '0')}";

    String formattedTicketNumber = lastTicketID.toString().padLeft(2, '0');

    // Generate the next ticket ID
    // int nextTicketID = lastTicketID + 1;
    // String ticketID = '#$nextTicketID';

    // int timestamp = DateTime.now().millisecondsSinceEpoch;
    // int random = Random().nextInt(9999);
    ticketID = "$formattedDate.$formattedTicketNumber";
    return ticketID;
  }

  Future<void> getBuilding() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('buildingNumbers').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      setState(() {
        buildingOptions = tempData;
      });
    }
  }

  Future<void> getFloor() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('floorNumbers').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      setState(() {
        floorOptions = tempData;
      });
      print(floorOptions);
    }
  }

  Future<void> getRoom() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('roomNumbers').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      setState(() {
        roomOptions = tempData;
      });
      print(roomOptions);
    }
  }

  Future<void> getAsset() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('assets').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      setState(() {
        assetOptions = tempData;
      });
    }
  }

  Future<void> getWork() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('works').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      setState(() {
        workOptions = tempData;
      });
    }
    setState(() {});
  }

  Future<void> fetchServiceProvider() async {
    List<String> tempData = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('members').get();

    if (querySnapshot.docs.isNotEmpty) {
      tempData = querySnapshot.docs.map((e) => e.id).toList();
    }
    for (var i = 0; i < tempData.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('members')
          .doc(tempData[i])
          .get();
      if (documentSnapshot.data() != null) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        if (_selectedWork == data['role'][0].toString()) {
          serviceProviders = data['fullName'];
        }

        print('serviceProviders $serviceProviders');
      }
    }

    setState(() {});
  }

  Future<void> storeRaisedTicket(String ticketID) async {
    String userName = await fetchName(widget.userID);
    // fetchServiceProvider();
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    int currentYear = DateTime.now().year;

    String currentMonth = DateFormat('MMM').format(DateTime.now());

    List<String> imageFilePaths =
        await _saveImagesToPersistentStorage(Imagenames!);
    await FirebaseFirestore.instance
        .collection("raisedTickets")
        // .doc(currentYear.toString())
        // .collection('months')
        // .doc(currentMonth.toString())
        // .collection('date')
        .doc(date)
        .collection('tickets')
        .doc(ticketID)
        .set({
      "month": currentMonth,
      "year": currentYear,
      "work": _selectedWork,
      "building": _selectedBuilding,
      "floor": _selectedFloor,
      "room": _selectedRoom,
      "asset": _selectedAsset,
      "remark": remarkController.text,
      "serviceProvider": serviceProviders,
      "imageFilePaths": imageFilePaths,
      "date": date,
      "user": widget.userID,
      'status': 'Open',
      "tickets": ticketID,
      "isSeen": true,
      "name": userName
    }).whenComplete(() {
      print("Data Stored Successfully");
    });
    await FirebaseFirestore.instance.collection("raisedTickets").doc(date).set({
      "raisedTickets": date,
    });
    // await FirebaseFirestore.instance
    //     .collection("raisedTickets")
    //     .doc(date)
    //     .collection('tickets')
    //     .doc(ticketID.toString())
    //     .set({
    //   "months": currentMonth,
    // });
  }

  Future<String> fetchName(String userID) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("members")
        .where('userId', isEqualTo: userID)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      List<dynamic> tempData = querySnapshot.docs.map((e) => e.data()).toList();
      return tempData[0]['fullName'] ?? '';
    } else {
      return '';
    }
  }

  Future<void> uploadFile(String id) async {
    try {
      String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
      int currentYear = DateTime.now().year;

      String currentMonth = DateFormat('MMM').format(DateTime.now());
      TaskSnapshot taskSnapshot;
      // ignore: duplicate_ignore
      if (filepath != null) {
        List<String> url = [];
        for (int i = 0; i < filepath!.length; i++) {
          taskSnapshot = await FirebaseStorage.instance
              .ref('Images/')
              .child(id)
              .child(filepath![i].path.split('/').last)
              .putData(filepath![i].readAsBytesSync());

          final downloadURL = await taskSnapshot.ref.getDownloadURL();
          url.add(downloadURL);
        }

        await FirebaseFirestore.instance
            .collection("raisedTickets")
            .doc(date)
            .collection('tickets')
            .doc(id)
            .update({
          "imageFilePaths": url,
        });
      } else {
        throw Exception('File bytes are null');
      }
    } on FirebaseException catch (e) {
      print('Failed to upload PDF file: $e');
    }
  }

  Future<List<String>> _saveImagesToPersistentStorage(
      List<String> imagePaths) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    List<String> savedPaths = [];
    for (String path in imagePaths) {
      File tempfile = File(path);
      String fileName = path.split('/').last;
      String newPath = '$appDocPath/$fileName';
      await tempfile.copy(newPath);
      savedPaths.add(newPath);
    }
    return savedPaths;
  }

  Future<bool> _requestGalleryPermission() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gallery permission denied')),
      );
      return false;
    }
    return true;
  }

  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
      return false;
    }
    return true;
  }

  Future<void> popupmessage(String msg) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              content: Text(
                msg,
                style: const TextStyle(fontSize: 14, color: Colors.green),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    userID: widget.userID,
                                  )));
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.green),
                    ))
              ],
            ),
          );
        });
  }
}
