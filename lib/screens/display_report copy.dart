import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/screens/image.dart';

class displayReport extends StatefulWidget {
  List<dynamic> ticketList = [];
  List<dynamic> ticketData = [];
  displayReport(
      {super.key, required this.ticketList, required this.ticketData});

  @override
  State<displayReport> createState() => _displayReportState();
}

class _displayReportState extends State<displayReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('Report Tickets'),
        ),
        body: ListView.builder(
            itemCount: widget.ticketList.length, //* 2 - 1,
            itemBuilder: (BuildContext context, int index) {
              List<String> imageFilePaths = List<String>.from(
                  widget.ticketData[index]['imageFilePaths'] ?? []);
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
                        Text('Ticket ${widget.ticketList[index]}',
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            ticketCard(
                                Icons.work,
                                "Work: ",
                                widget.ticketData[index]['work'] ?? "N/A",
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
                                widget.ticketData[index]['building'] ?? "N/A",
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
                                widget.ticketData[index]['floor'].toString(),
                                index)
                            // const Icon(Icons.layers,
                            //     color: Colors.deepPurple),
                            // const SizedBox(width: 20),
                            // const Text(
                            //   'Floor: ',
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),
                            // const SizedBox(width: 10),
                            // Text(ticketListData[index]['floor'] ?? "N/A")
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
                                widget.ticketData[index]['room'] ?? "N/A",
                                index)
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ticketCard(
                                Icons.account_balance,
                                "Asset:",
                                widget.ticketData[index]['asset'] ?? "N/A",
                                index)
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(children: [
                          ticketCard(
                              Icons.comment,
                              'Remark: ',
                              widget.ticketData[index]['remark'] ?? "N/A",
                              index)
                        ]),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            ticketCard(
                                Icons.build,
                                'ServiceProvider:',
                                widget.ticketData[index]['serviceProvider'] ??
                                    "N/A",
                                index)
                          ],
                        ),
                        SizedBox(height: 10),
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
                                              builder: (context) => ImageScreen(
                                                    pageTitle: 'pendingPage',
                                                    imageFiles: imageFilePaths,
                                                    initialIndex: index2,
                                                    imageFile:
                                                        imageFilePaths[index2],
                                                    ticketId: widget
                                                        .ticketList[index],
                                                  )));
                                    },
                                    child: Image.network(
                                      imageFilePaths[index2],
                                    ),
                                  ))),
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
              );
              // ListTile(
              //   title: Text('Ticket ${ticketList[index]}'),
              //   trailing: ElevatedButton(
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => pendingstatus(
              //                       Number: ticketList[index],
              //                     )
              //                 // TicketScreen(
              //                 //       Number: ticketList[index],
              //                 //       showResolvedTickets: false,
              //                 //     )
              //                 ));
              //       },
              //       child: const Text('Open')),
              //   onTap: () {
              //     Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => // NotificationScreen()
              //                 pendingstatus(
              //                   Number: ticketList[index],
              //                 )));
              //   },
              // );
            }));
  }

  Widget ticketCard(
      IconData icons, String title, String ticketListData, int index) {
    return Row(
      children: [
        Icon(icons, color: Colors.deepPurple),
        const SizedBox(width: 20),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Text(ticketListData ?? "N/A")
      ],
    );
  }
}
