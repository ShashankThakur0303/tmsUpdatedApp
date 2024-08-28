import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_management_system/screens/image.dart';

int globalIndex = 0;

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key, required this.userID});
  String userID;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> ticketList = [];
  List<dynamic> ticketid = [];
  List<dynamic> ticketListData = [];

  String work = '';
  String building = '';
  String floor = '';
  String room = '';
  String asset = '';
  String remark = '';
  List<dynamic> serviceprovider = [];

  final String imagePath = 'Images/';
  List<String> _imageUrls = [];
  bool _isLoading = true;
  bool _isFirstTime = true;

  @override
  void initState() {
    fetchImageUrls();
    getNotificationScreenTicket().whenComplete(() async {
      // setNotificationIsSeen().whenComplete(() {

      // });
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  Future<void> fetchImageUrls() async {
    ListResult result = await FirebaseStorage.instance.ref('Images/').listAll();
    List<String> urls = await Future.wait(
      result.items.map((ref) => ref.getDownloadURL()).toList(),
    );
    _imageUrls = urls;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 141, 36, 41),
          title: const Text('Notification'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: ticketList.length, //* 2 - 1,
                itemBuilder: (BuildContext context, int index) {
                  List<dynamic> imageFilePaths =
                      ticketListData[index]['imageFilePaths'];
                  // if (index.isOdd) {
                  //   return Divider();
                  // }
                  //final itemIndex = index ~/ 3;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('Ticket ${ticketList[index]}',
                                style: const TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                ticketCard(
                                    Icons.work,
                                    "Work: ",
                                    ticketListData[index]['work'] ?? "N/A",
                                    index)
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                ticketCard(
                                    Icons.business,
                                    'Building;',
                                    ticketListData[index]['building'] ?? "N/A",
                                    index)
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                ticketCard(
                                    Icons.layers,
                                    "Floor: ",
                                    ticketListData[index]['floor'].toString(),
                                    index)
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                ticketCard(
                                    Icons.room,
                                    'Room: ',
                                    ticketListData[index]['room'] ?? "N/A",
                                    index)
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ticketCard(
                                    Icons.account_balance,
                                    "Asset:",
                                    ticketListData[index]['asset'] ?? "N/A",
                                    index)
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(children: [
                              ticketCard(
                                  Icons.comment,
                                  'Remark: ',
                                  ticketListData[index]['remark'] ?? "N/A",
                                  index)
                            ]),
                            const SizedBox(height: 10),

                            Row(children: [
                              ticketCard(
                                  Icons.design_services,
                                  'Service Provider: ',
                                  ticketListData[index]['serviceProvider'] ??
                                      "N/A",
                                  index)
                            ]),
                            const SizedBox(
                              height: 10,
                            ),

                            Row(children: [
                              ticketCard(
                                  Icons.date_range,
                                  'Close Date: ',
                                  ticketListData[index]['closedDate'] ?? "N/A",
                                  index)
                            ]),
                            const SizedBox(
                              height: 10,
                            ),

                            SizedBox(
                              height: 50,
                              child: ListView.builder(
                                  itemCount: imageFilePaths.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index2) => Container(
                                      height: 80,
                                      width: 60,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageScreen(
                                                        pageTitle:
                                                            'NotificationScreenPage',
                                                        imageFiles:
                                                            imageFilePaths,
                                                        initialIndex: index2,
                                                        imageFile:
                                                            imageFilePaths[
                                                                index2],
                                                        ticketId:
                                                            ticketList[index],
                                                      )));
                                        },
                                        child: Image.network(
                                          imageFilePaths[index2],
                                        ),
                                      ))),
                            )
                           
                          ],
                        ),
                      ),
                    ),
                  );
                
                }));
  }

  Future<void> getNotificationScreenTicket() async {
    try {
      ticketList.clear();
      QuerySnapshot monthQuery =
          await FirebaseFirestore.instance.collection("raisedTickets").get();
      List<dynamic> dateList = monthQuery.docs.map((e) => e.id).toList();
      for (int j = 0; j < dateList.length; j++) {
        List<dynamic> temp = [];
        QuerySnapshot ticketQuery = await FirebaseFirestore.instance
            .collection("raisedTickets")
            .doc(dateList[j])
            .collection('tickets')
            .where('user', isEqualTo: widget.userID)
            .where('status', isEqualTo: 'Close')
            .where('isUserSeen', isEqualTo: true)
            .get();
        temp = ticketQuery.docs.map((e) => e.id).toList();
        // ticketList = ticketList + temp;

        if (temp.isNotEmpty) {
          ticketList.addAll(temp);
          for (int k = 0; k < temp.length; k++) {
            DocumentSnapshot ticketDataQuery = await FirebaseFirestore.instance
                .collection("raisedTickets")
                .doc(dateList[j])
                .collection('tickets')
                .doc(temp[k])
                .get();
            if (ticketDataQuery.exists) {
              Map<String, dynamic> mapData =
                  ticketDataQuery.data() as Map<String, dynamic>;
              asset = mapData['asset'].toString();
              building = mapData['building'].toString();
              floor = mapData['floor'].toString();
              remark = mapData['remark'].toString();
              room = mapData['room'].toString();
              work = mapData['work'].toString();
              // serviceprovider = mapData['serviceProvider'].toString();
              ticketListData.add(mapData);
              // print('$mapData abc');
            }
          }
        }
      }
    } catch (e) {
      print("Error Fetching tickets: $e");
    }
  }

  Widget ticketCard(
      IconData icons, String title, String ticketListData, int index) {
    return Row(
      children: [
        Icon(icons, color: Colors.deepPurple),
        const SizedBox(width: 20),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Text(ticketListData ?? "N/A")
      ],
    );
  }

  Widget listCard(
      IconData icons, String title, List<dynamic> ticketData, int index) {
    return Row(
      children: [
        Icon(icons, color: Colors.deepPurple),
        const SizedBox(width: 20),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Column(
          children: List.generate(
              ticketData.length, (index) => Text(ticketData[index])),
        )
        // Text(ticketData ?? "N/A")
      ],
    );
  }
}
