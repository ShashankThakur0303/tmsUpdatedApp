import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/Service%20Provider/reports_ticket_page.dart';

class report1 extends StatefulWidget {
  const report1({super.key});

  @override
  State<report1> createState() => _report1State();
}

class _report1State extends State<report1> {
  // final List<String> serviceProviders = [
  //   'Provider A',
  //   'Provider B',
  //   'Provider C',
  //   'Provider D',
  // ];

  bool isLoading = true;

  List<dynamic> allTicketsData = [];

  String? _selectedServiceProvider;

  List<String> mapKeys = [];

  @override
  void initState() {
    getAllTicketData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Reports",
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: allTicketsData.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportTicketScreen(
                                    ticketNo: mapKeys[index],
                                    asset: allTicketsData[index]['asset'],
                                    building: allTicketsData[index]['building'],
                                    floor: allTicketsData[index]['floor'],
                                    remark: allTicketsData[index]['remark'],
                                    room: allTicketsData[index]['room'],
                                    work: allTicketsData[index]['work'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 5.0,
                              ),
                              child: Card(
                                elevation: 5.0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Ticket ${mapKeys[index]}",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      Text(
                                        allTicketsData[index]['status']
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ));
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}';
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  Future getAllTicketData() async {
    allTicketsData.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('raisedTickets').get();

    List<String> tempKeys = querySnapshot.docs.map((e) => e.id).toList();

    allTicketsData = querySnapshot.docs.map((e) => e.data()).toList();

    // QuerySnapshot resolvedTicketQuery =
    //     await FirebaseFirestore.instance.collection('resolvedTicket').get();

    // tempKeys = tempKeys + resolvedTicketQuery.docs.map((e) => e.id).toList();

    // allTicketsData =
    //     allTicketsData + resolvedTicketQuery.docs.map((e) => e.data()).toList();

    mapKeys = tempKeys;

    print(allTicketsData);

    isLoading = false;
    setState(() {});
  }
}
