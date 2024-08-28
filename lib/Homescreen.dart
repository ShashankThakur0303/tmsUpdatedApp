import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/Login/login.dart';
import 'package:ticket_management_system/provider/pieChart_provider.dart';
import 'package:ticket_management_system/responsive/responsive.dart';
import 'package:ticket_management_system/screens/filter_report.dart';
import 'package:ticket_management_system/screens/notification.dart';
import 'package:ticket_management_system/screens/pending.dart';
import 'package:ticket_management_system/screens/profile.dart';
import 'package:ticket_management_system/screens/raise.dart';
import 'package:ticket_management_system/screens/split_Screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.userID});
  String userID;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  GifController? _gifController;
  int notificationNum = 0;
 
  List<String> buttons = [
    'Raise Ticket',
    'Pending Tickets',
    'Reports',
    'Profile',
  ];

  List<Widget Function(String)> screens = [
    (userID) => Raise(
          userID: userID,
        ),
    //Pending(),
    (userID) => pending(
          userID: userID,
        ),
    (userID) => FilteredReport(
          userID: userID,
        ),
    (userID) => profile(
          userID: userID,
        ),
  ];

  int resolvedTicketLen = 0;
  int pendingTicketLen = 0;

  @override
  void initState() {
    getPendingTicket().whenComplete(() async {
      await getNotification();
      isLoading = false;
      setState(() {});
    });
    super.initState();
    _gifController = GifController(vsync: this);
  }

  @override
  void dispose() {
    _gifController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PiechartProvider>(context, listen: false);
    var screenSize = MediaQuery.of(context).size;
    return ReponsiveWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            'T.🅼.S',
            style: TextStyle(
                color: Color.fromARGB(255, 141, 36, 41), fontSize: 30),
          ),
          leading: Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(
                        userID: widget.userID,
                      ),
                    ),
                  ).whenComplete(() {
                    getNotification().whenComplete(() {
                      setState(() {});
                    });
                  });
                },
                icon: const Icon(
                  size: 30,
                  Icons.notifications_active,
                  color: Color.fromARGB(255, 141, 36, 41),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    notificationNum.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Color.fromARGB(255, 197, 66, 73),
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => spliScreen(
                                  userID: widget.userID,
                                )));
                  },
                  child: const Center(
                    child: Text(
                      'User',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const LoginPage()),
                  // );
                },
                icon: const Icon(
                  Icons.power_settings_new,
                  color: Color.fromARGB(255, 141, 36, 41),
                  size: 30,
                )),
          ],
        ),
        body: isLoading
            ? Center(
                child: Gif(
                  image: AssetImage('assets/looding.gif'),
                  controller: _gifController,
                  autostart: Autostart.loop,
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  bool isLandscape =
                      constraints.maxWidth > constraints.maxHeight;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: screenSize.width * 0.95,
                            height: screenSize.height * 0.5,
                            child: GridView.builder(
                              itemCount: buttons.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isLandscape ? 4 : 2,
                                childAspectRatio: isLandscape ? 1.2 : 1,
                                crossAxisSpacing: 4.0,
                              ),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  screens[index](widget.userID),
                                            ),
                                          ).whenComplete(() {
                                            getPendingTicket().whenComplete(() {
                                              provider.reloadWidget(true);
                                              // print("Hello Worlds");
                                            });
                                          }),
                                          child: getIcon(buttons[index]),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                screens[index](widget.userID),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        buttons[index],
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(10.0),
                            child: Card(
                              elevation: 10.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: const Text(
                                      'Ticket Overview',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 15),
                                            RichText(
                                              text: TextSpan(children: [
                                                WidgetSpan(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 5.0,
                                                    ),
                                                    child: CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                141, 36, 41),
                                                        child: Consumer<
                                                            PiechartProvider>(
                                                          builder: (context,
                                                              value, child) {
                                                            return Text(
                                                              pendingTicketLen
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            );
                                                          },
                                                        )),
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                  child: SizedBox(
                                                    width: 10,
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                    child: Text(
                                                  'Pending Ticket',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))
                                              ]),
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            RichText(
                                              text: TextSpan(children: [
                                                WidgetSpan(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 5.0,
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          Colors.orange,
                                                      child: Text(
                                                        resolvedTicketLen
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                  child: SizedBox(
                                                    width: 10,
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                  child: Text(
                                                    'Completed Ticket',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ]),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: Consumer<PiechartProvider>(
                                            builder: (context, value, child) {
                                              return PieChart(
                                                PieChartData(
                                                  centerSpaceRadius: 20,
                                                  sections: [
                                                    PieChartSectionData(
                                                      color: Color.fromARGB(
                                                          255, 141, 36, 41),
                                                      value: 40,
                                                      title: pendingTicketLen
                                                          .toString(),
                                                      titleStyle:
                                                          const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                      ),
                                                      radius: 40,
                                                    ),
                                                    PieChartSectionData(
                                                      color: Colors.orange,
                                                      value: 20,
                                                      title: resolvedTicketLen
                                                          .toString(),
                                                      titleStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                      radius: 40,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future getNotification() async {
    try {
      int currentYear = DateTime.now().year;
      QuerySnapshot dateQuery =
          await FirebaseFirestore.instance.collection("raisedTickets").get();
      List<dynamic> dateList = dateQuery.docs.map((e) => e.id).toList();
      for (int j = 0; j < dateList.length; j++) {
        List<dynamic> temp = [];
        QuerySnapshot ticketQuery = await FirebaseFirestore.instance
            .collection("raisedTickets")
            .doc(dateList[j])
            .collection('tickets')
            .where('status', isEqualTo: 'Close')
            .where('isUserSeen', isEqualTo: true)
            .get();
        temp = ticketQuery.docs.map((e) => e.id).toList();
        notificationNum = notificationNum + temp.length;
        print('this is temp $temp');
      }
    } catch (e) {
      print("Error Fetching ticket length: $e");
    }
  }

  Future getPendingTicket() async {
    try {
      pendingTicketLen = 0;
      resolvedTicketLen = 0;
      int currentYear = DateTime.now().year;
      QuerySnapshot dateQuery =
          await FirebaseFirestore.instance.collection("raisedTickets").get();
      List<dynamic> dateList = dateQuery.docs.map((e) => e.id).toList();
      for (int j = 0; j < dateList.length; j++) {
        List<dynamic> temp = [];
        QuerySnapshot pendingTicketQuery = await FirebaseFirestore.instance
            .collection("raisedTickets")
            .doc(dateList[j])
            .collection('tickets')
            .where('status', isEqualTo: 'Open')
            .where('user', isEqualTo: widget.userID)
            .get();
        QuerySnapshot completedTicketQuery = await FirebaseFirestore.instance
            .collection("raisedTickets")
            .doc(dateList[j])
            .collection('tickets')
            .where('status', isEqualTo: 'Close')
            .where('user', isEqualTo: widget.userID)
            .get();
        List<dynamic> pendingTicketData =
            pendingTicketQuery.docs.map((e) => e.id).toList();
        pendingTicketLen = pendingTicketLen + pendingTicketData.length;
        List<dynamic> completedTicketData =
            completedTicketQuery.docs.map((e) => e.id).toList();
        resolvedTicketLen = resolvedTicketLen + completedTicketData.length;
        // print(completedTicketData);
      }
    } catch (e) {
      print("Error Fetching tickets: $e");
    }
  }

  Future getResolvedTicket() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('resolvedTicket').get();

    List<dynamic> resolvedTicketData =
        querySnapshot.docs.map((e) => e.id).toList();
    resolvedTicketLen = resolvedTicketData.length;
  }

  Widget getIcon(String iconName) {
    switch (iconName) {
      case "Raise Ticket":
        return const Icon(
          Icons.receipt_long_rounded,
          size: 70,
          color: Color.fromARGB(255, 141, 36, 41),
        );
      case "Reports":
        return const Icon(
          Icons.report_sharp,
          size: 70,
          color: Color.fromARGB(255, 141, 36, 41),
        );
      case "Profile":
        return const Icon(
          Icons.person_outlined,
          size: 70,
          color: Color.fromARGB(255, 141, 36, 41),
        );
      default:
        return const Icon(
          Icons.pending_actions_outlined,
          size: 70,
          color: Color.fromARGB(255, 141, 36, 41),
        );
    }
  }

  Future storeCompletedTicket(
      String year, String openDate, String ticketNumber) async {
    FirebaseFirestore.instance
        .collection("raisedTickets")
        .doc(openDate)
        .collection('tickets')
        .doc(ticketNumber)
        .update({
      "isUserSeen": false,
    });
  }
}
