import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticket_management_system/Service%20Provider/reports_ticket_page.dart';

class ServiceReportScreen extends StatefulWidget {
  const ServiceReportScreen({super.key});

  @override
  State<ServiceReportScreen> createState() => _ServiceReportScreenState();
}

class _ServiceReportScreenState extends State<ServiceReportScreen> {
  List<dynamic> ticketList = [];

  bool isLoading = true;

  List<dynamic> allTicketsData = [];

  List<String> mapKeys = [];

  @override
  void initState() {
    getPendingTicket();
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
            : Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ticketList.length,
                  itemBuilder: (context, index) {
                    Duration tat = allTicketsData[index]['status'] == "Closed"
                        ? getTurnAroundTime(allTicketsData[index]['date'],
                            allTicketsData[index]['closedDate'])
                        : const Duration(days: 0);
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportTicketScreen(
                              ticketNo: ticketList[index],
                              asset: allTicketsData[index]['asset'] ?? "",
                              building: allTicketsData[index]['building'] ?? "",
                              floor: allTicketsData[index]['floor'] ?? "",
                              remark: allTicketsData[index]['remark'] ?? "",
                              room: allTicketsData[index]['room'] ?? "",
                              work: allTicketsData[index]['work'] ?? "",
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: const EdgeInsets.only(
                                      left: 10.0,
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    height: 40,
                                    child: Text(
                                      "Ticket ${ticketList[index]}",
                                    ),
                                  ),
                                  allTicketsData[index]['status'] == "Close"
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child:
                                              Text("TAT: ${tat.inDays} Days"))
                                      : Container()
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, bottom: 5.0),
                                    child: Text(allTicketsData[index]
                                            ['status'] ??
                                        "open"),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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

  Future<void> getPendingTicket() async {
    try {
      ticketList.clear();
      String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
      int currentYear = DateTime.now().year;

      String currentMonth = DateFormat('MMM').format(DateTime.now());

      QuerySnapshot monthQuery = await FirebaseFirestore.instance
          .collection("raisedTickets")
          .doc(currentYear.toString())
          .collection('months')
          .get();
      List<dynamic> months = monthQuery.docs.map((e) => e.id).toList();
      for (int i = 0; i < months.length; i++) {
        QuerySnapshot dateQuery = await FirebaseFirestore.instance
            .collection("raisedTickets")
            .doc(currentYear.toString())
            .collection('months')
            .doc(months[i])
            .collection('date')
            .get();
        List<dynamic> dateList = dateQuery.docs.map((e) => e.id).toList();
        for (int j = 0; j < dateList.length; j++) {
          List<dynamic> temp = [];
          QuerySnapshot ticketQuery = await FirebaseFirestore.instance
              .collection("raisedTickets")
              .doc(currentYear.toString())
              .collection('months')
              .doc(months[i])
              .collection('date')
              .doc(dateList[j])
              .collection('tickets')
              // .where("status", isEqualTo: "Open")
              .get();
          temp = ticketQuery.docs.map((e) => e.id).toList();
          ticketList = ticketList + temp;
          print(temp);
          for (int k = 0; k < temp.length; k++) {
            DocumentSnapshot ticketDataQuery = await FirebaseFirestore.instance
                .collection("raisedTickets")
                .doc(currentYear.toString())
                .collection('months')
                .doc(months[i])
                .collection('date')
                .doc(dateList[j])
                .collection('tickets')
                .doc(temp[k])
                .get();

            if (ticketDataQuery.exists) {
              Map<String, dynamic> mapData =
                  ticketDataQuery.data() as Map<String, dynamic>;
              allTicketsData.add(mapData);
              // print(mapData);
            } //month,year,user
          }
          isLoading = false;
          setState(() {});
        }
      }
    } catch (e) {
      print("Error Fetching tickets: $e");
    }
  }

  Duration getTurnAroundTime(String openDate, String closedDate) {
    DateTime a1 = DateFormat('dd-MM-yyyy').parse(openDate);
    DateTime a2 = DateFormat('dd-MM-yyyy').parse(closedDate);
    Duration a3 = a2.difference(a1);
    print("Duration ${a3.inDays} Days");
    return a3;
  }
}
