import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class serviceProvieder_ticketScreen extends StatefulWidget {
  final String Number;
  final bool showResolvedTickets;
  const serviceProvieder_ticketScreen(
      {super.key, required this.Number, required this.showResolvedTickets});

  @override
  State<serviceProvieder_ticketScreen> createState() => _serviceProvieder_ticketScreenState();
}

class _serviceProvieder_ticketScreenState extends State<serviceProvieder_ticketScreen> {
  String asset = '';
  String building = '';
  String floor = '';
  String remark = '';
  String room = '';
  String work = '';
  String selectedServiceProvider = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getTicketData(widget.showResolvedTickets).whenComplete(
      () {
        loading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text('Ticket ${widget.Number}'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  customRow('asset', asset),
                  customRow('building', building),
                  customRow('floor', floor),
                  customRow('remark', remark),
                  customRow('room', room),
                  customRow('work', work),
                  customRow('serviceprovider', selectedServiceProvider),
                ],
              ),
            ),
    );
  }

  Widget customRow(String title, String message) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(message),
        ],
      ),
    );
  }

  Future<void> getTicketData(bool showResolvedTickets) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(showResolvedTickets ? 'resolvedTicket' : 'raisedTickets')
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
      selectedServiceProvider = mapData['serviceprovider'] ?? "";
      setState(() {
        loading = false;
      });
    }
  }
}
