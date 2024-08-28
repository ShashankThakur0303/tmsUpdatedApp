import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class pendingstatus_service extends StatefulWidget {
  pendingstatus_service({
    super.key,
    required this.ticketNumber,
    required this.openDate,
    required this.asset,
    required this.building,
    required this.floor,
    required this.remark,
    required this.room,
    required this.serviceprovider,
    required this.user,
    required this.work,
    required this.month,
    required this.year,
  });
  String ticketNumber;
  String asset;
  String building;
  String floor;
  String remark;
  String room;
  String work;
  String openDate;
  String month;
  String year;
  String serviceprovider;
  String user;

  @override
  State<pendingstatus_service> createState() => _pendingstatus_serviceState();
}

class _pendingstatus_serviceState extends State<pendingstatus_service> {
  List<dynamic> ticketList = [];
  List<dynamic> ticketListData = [];

  bool loading = true;
  final dateFormatter = DateFormat('yyyy-MM-dd');
  final timeFormatter = DateFormat('HH:mm:ss');

  @override
  void initState() {
    super.initState();
    // getTicketData().whenComplete(
    //   () {

    //   },
    // );
    print('hello${widget.openDate}');
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text('Ticket ${widget.ticketNumber}'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 197, 66, 73)),
      body: Center(
        child: Container(
          height: 500,
          child: Card(
            color: Color.fromARGB(255, 240, 210, 247),
            elevation: 10,
            shadowColor: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      customCard(Icons.work, 'Work', widget.work),
                    ],
                  ),
                  Row(
                    children: [
                      customCard(Icons.business, 'Building', widget.building),
                    ],
                  ),
                  Row(
                    children: [
                      customCard(Icons.layers, 'Floor', widget.floor),
                    ],
                  ),
                  Row(
                    children: [
                      customCard(Icons.room, 'Room', widget.room),
                    ],
                  ),
                  Row(
                    children: [
                      customCard(Icons.account_balance, 'Asset', widget.asset),
                    ],
                  ),
                  Row(
                    children: [
                      customCard(Icons.comment, 'Remark', widget.remark),
                    ],
                  ),
                  Row(
                    children: [
                      customCard(Icons.design_services, 'Serviceprovider',
                          widget.serviceprovider),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      customAlert();
                    },
                    child: Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              right: 5.0,
                            ),
                            child: const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            child: const Text(
                              "Task Accomplished",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future storeCompletedTicket(
      String year, String month, String openDate, String ticketNumber) async {
    String currentMonth = DateFormat('MMM').format(DateTime.now());
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    DateTime a1 = DateFormat('dd-MM-yyyy').parse(openDate);
    DateTime a2 = DateFormat('dd-MM-yyyy').parse(currentDate);
    Duration a3 = a2.difference(a1);
    print("Duration $a3");

    FirebaseFirestore.instance
        .collection("raisedTickets")
        .doc(openDate)
        .collection('tickets')
        .doc(ticketNumber)
        .update({
      'status': 'Close',
      'tat': a3.inDays,
      "isSeen": false,
      "isUserSeen": true,
      'closedDate': currentDate
    }).whenComplete(() async {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Ticket Resolved!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void customAlert() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Are You Sure Task Is Completed!",
            ),
            icon: const Icon(
              Icons.warning,
              color: Colors.blue,
              size: 60,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.year.isNotEmpty &&
                          widget.month.isNotEmpty &&
                          widget.openDate.isNotEmpty &&
                          widget.ticketNumber.isNotEmpty) {
                        final DateTime now = DateTime.now();
                        final formattedDate = dateFormatter.format(now);
                        final formattedTime = timeFormatter.format(now);
                        storeCompletedTicket(widget.year, widget.month,
                                widget.openDate, widget.ticketNumber)
                            .whenComplete(() {
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: const Text(
                      "OK",
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget customCard(IconData icons, String title, String message) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icons, color: Color.fromARGB(255, 197, 66, 73)),
          SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(width: 10),
          Text(
            message,
            style: TextStyle(fontSize: 18),
          ),
        ],
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

  // Future<void> getTicketData() async {
  //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //       .collection('raisedTickets')
  //       .doc(widget.Number)
  //       .get();
  //   if (documentSnapshot.exists) {
  //     Map<String, dynamic> mapData =
  //         documentSnapshot.data() as Map<String, dynamic>;
  //     asset = mapData['asset'];
  //     building = mapData['building'];
  //     floor = mapData['floor'];
  //     remark = mapData['remark'];
  //     room = mapData['room'];
  //     work = mapData['work'];
  //     openDate = mapData['date'];
  //     serviceprovider = mapData['serviceprovider'] ?? "";
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  Future<void> getTicketData() async {
    try {
      ticketList.clear();

      QuerySnapshot dateQuery =
          await FirebaseFirestore.instance.collection("raisedTickets").get();
      List<dynamic> dateList = dateQuery.docs.map((e) => e.id).toList();
      for (int j = 0; j < dateList.length; j++) {
        List<dynamic> temp = [];
        QuerySnapshot ticketQuery = await FirebaseFirestore.instance
            .collection("raisedTickets")
            .doc(dateList[j])
            .collection('tickets')
            .get();
        temp = ticketQuery.docs.map((e) => e.id).toList();
        ticketList = ticketList + temp;
      }
    } catch (e) {
      print("Error Fetching tickets: $e");
    }
  }
}
