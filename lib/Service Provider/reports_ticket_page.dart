import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportTicketScreen extends StatefulWidget {
  final String ticketNo;
  final String asset;
  final String building;
  final String floor;
  final String remark;
  final String room;
  final String work;

  const ReportTicketScreen(
      {super.key,
      required this.ticketNo,
      required this.asset,
      required this.building,
      required this.floor,
      required this.remark,
      required this.room,
      required this.work});

  @override
  State<ReportTicketScreen> createState() => _ReportTicketScreenState();
}

class _ReportTicketScreenState extends State<ReportTicketScreen> {
  List<dynamic> ticketData = [];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ticketNo),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                customRow(Icons.work, "Work:", widget.work),
                SizedBox(height: 10),
                customRow(Icons.business, "Building:", widget.building),
                SizedBox(height: 10),
                customRow(Icons.layers, "Floor:", widget.floor),
                SizedBox(height: 10),
                customRow(Icons.room, "Room:", widget.room),
                SizedBox(height: 10),
                customRow(Icons.account_balance, "Asset:", widget.asset),
                SizedBox(height: 10),
                customRow(Icons.comment, "Remark:", widget.remark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customRow(IconData icons, String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icons, color: Colors.deepPurple),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
