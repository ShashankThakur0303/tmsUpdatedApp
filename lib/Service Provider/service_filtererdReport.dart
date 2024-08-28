import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/screens/display_report.dart';

class FilteredReport extends StatefulWidget {
  FilteredReport({super.key, required this.userID});
  String userID;
  @override
  State<FilteredReport> createState() => _FilteredReportState();
}

class _FilteredReportState extends State<FilteredReport> {
  TextEditingController assetController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController workController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController ticketController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  List<String> buildingList = [];
  List<dynamic> filterData = [];
  List<String> floorList = [];
  List<String> roomList = [];
  List<String> assetList = [];
  List<String> userList = [];
  List<String> allTicketList = [];
  List<String> workList = [];
  List<String> uniqueFloorList = [];
  String? selectedAsset;
  String? selectedFloor;
  String? selectedRoom;
  String selectedStartDate = '';
  String selectedEndDate = '';
  String? selectedUser;
  String? selectedTicket;
  String? selectedbuilding;
  String? selectedWork;
  String? selectedStatus;

  List<String> floorNumberList = [];
  List<dynamic> allData = [];
  List<dynamic> serviceProviderList = [];
  String? selectedTicketNumber;
  List<String> allDateData = [];
  List<String> allTicketData = [];
  List<String> allAssetData = [];
  List<String> allUserData = [];
  List<String> buildingNumberList = [];
  List<String> allFloorData = [];
  List<String> allWorkData = [];
  List<String> allRoomData = [];
  List<String> allStatusData = ['Open', 'Close'];

  List<dynamic> ticketList = [];

  List<String> serviceProvider = [];
  List<String>? selectedSPList = [];

  String? selectedServiceProvider;
  List<String> roomNumberList = [];
  List<String> ticketNumberList = [];
  bool isLoading = true;
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2020, 01, 01),
    end: DateTime(2025, 01, 01),
  );

  DateTime rangeStartDate = DateTime.now();
  DateTime? rangeEndDate = DateTime.now();
  @override
  void initState() {
    fetchServiceProvider();
    fetchUser();
    getTicketList();
    getWorkList();
    getBuilding().whenComplete(() {
      getFloor().whenComplete(() {
        getRoom().whenComplete(() {
          getAsset().whenComplete(() {
            setState(() {});
          });
        });
      });
    });

    setState(() {
      isLoading = false;
    });

    super.initState();
  }

  TextEditingController ticketnumberController = TextEditingController();
  TextEditingController serviceProviderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'All Tickets Report',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 141, 36, 41),

        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20),
        //     child: IconButton(
        //         onPressed: () {
        //           signOut(context);
        //         },
        //         icon: const Icon(
        //           Icons.power_settings_new_outlined,
        //           size: 30,
        //           color: white,
        //         )),
        //   )
        // ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                          elevation: 5,
                          child: SizedBox(
                            width: 345,
                            height: 70,
                            child: TextButton(
                              onPressed: () {
                                pickDateRange();
                                setState(() {});
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  // Text(
                                  //   textAlign: TextAlign.justify,
                                  //   'Search Date: \n $selectedDate',
                                  //   style: const TextStyle(
                                  //       color: Colors.black,
                                  //       fontSize: 16),
                                  // ),
                                  child: Column(
                                    children: [
                                      RichText(
                                          text: TextSpan(
                                              text: 'Search Date: \n',
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              children: [
                                            TextSpan(
                                                text: selectedStartDate
                                                        .isNotEmpty
                                                    ? " $selectedStartDate TO $selectedEndDate  "
                                                    : '',
                                                style: const TextStyle(
                                                    backgroundColor:
                                                        Colors.purple,
                                                    color: Colors.white)),
                                          ])),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 350,
                    height: 70,
                    child: customDropDown(
                      'Select Ticket',
                      ticketList.map((e) => e.toString()).toList(),
                      "Search Ticket",
                      1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown('Select Status', allStatusData,
                              "Search Status", 8),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown(
                            'Select Work',
                            allWorkData,
                            "Search Work",
                            9,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown('Select Building',
                              buildingNumberList, "Search Building", 2),
                        ),
                      ]),
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown('Select Floor', floorNumberList,
                              "Search Floor", 3),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown(
                              'Select Room', roomNumberList, "Search Room", 4),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown(
                              'Select Asset', assetList, "Search Asset", 6),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: customDropDown('Select Service Provider',
                        //       serviceProvider, "Search Service Provider", 7),
                        // ),
                      ]),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  filterTickets(widget.userID).whenComplete(() {
                                    print(
                                        'selectedServiceProvider: $selectedServiceProvider');
                                    if (selectedStatus == 'All') {
                                      popupAlertmessage(
                                          'Please specify one more filter');
                                    } else {
                                      if (selectedStatus != null ||
                                          selectedTicket != null ||
                                          selectedWork != null ||
                                          selectedbuilding != null ||
                                          selectedFloor != null ||
                                          selectedRoom != null ||
                                          selectedAsset != null ||
                                          selectedUser != null ||
                                          selectedServiceProvider != null ||
                                          selectedStartDate.isNotEmpty ||
                                          selectedEndDate.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return ReportDetails(
                                              ticketList: ticketList,
                                              ticketData: filterData,
                                            );
                                          }),
                                        ).whenComplete(() {
                                          print('ticketList $ticketList');
                                          print('filterData $filterData');
                                          selectedWork = null;
                                          selectedServiceProvider = null;
                                          selectedStatus = null;
                                          selectedAsset = null;
                                          selectedUser = null;
                                          selectedRoom = null;
                                          selectedFloor = null;
                                          selectedbuilding = null;
                                          selectedTicket = null;
                                          selectedStartDate = '';
                                          selectedEndDate = '';
                                          ticketList.clear();
                                          filterData.clear();
                                          setState(() {});
                                        });
                                      } else {
                                        popupAlertmessage(
                                            'Please select any filter');
                                      }
                                    }
                                  });
                                },
                                child: const Text('Get Report'),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     const Refreshscreen()))
                              //         .whenComplete(() {
                              //       selectedWork = null;
                              //       selectedServiceProvider = null;
                              //       selectedStatus = null;
                              //       selectedAsset = null;
                              //       selectedUser = null;
                              //       selectedRoom = null;
                              //       selectedFloor = null;
                              //       selectedbuilding = null;
                              //       selectedTicket = null;
                              //       selectedStartDate = '';
                              //       selectedEndDate = '';
                              //       ticketList.clear();
                              //       filterData.clear();
                              //       setState(() {});
                              //     });
                              //   },
                              //   child: const Text('Refresh'),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  void popupAlertmessage(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              content: Text(
                msg,
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
          );
        });
  }

  Future<void> fetchUser() async {
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

        // String fullName = data['fullName'] + " " + data['userId'];
        String fullName = data['userId'];
        // print(fullName);
        userList.add(fullName);
      }
    }

    setState(() {});
  }

  Future<void> fetchServiceProvider() async {
    List<String> tempData = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('members')
        .where('role', isNotEqualTo: null)
        .get();

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
        serviceProvider.add(data['fullName']);
      }
    }
    setState(() {});
  }

  Future<void> getTicketList() async {
    // final provider = Provider.of<AllRoomProvider>(context, listen: false);
    // provider.setBuilderList([]);
    try {
      ticketList.clear();
      int currentYear = DateTime.now().year;

      QuerySnapshot dateQuery =
          await FirebaseFirestore.instance.collection("raisedTickets").get();
      List<dynamic> dateList = dateQuery.docs.map((e) => e.id).toList();
      for (int j = 0; j < dateList.length; j++) {
        List<String> temp = [];
        QuerySnapshot ticketQuery = await FirebaseFirestore.instance
            .collection("raisedTickets")
            .doc(dateList[j])
            .collection('tickets')
            .get();
        temp = ticketQuery.docs.map((e) => e.id).toList();
        ticketList = ticketList + temp;
      }
    } catch (e) {
      print(e);
    }
    //// provider.setBuilderList(ticketList);
    setState(() {});
  }

  Future<void> getBuilding() async {
    // final provider = Provider.of<AllBuildingProvider>(context, listen: false);
    // provider.setBuilderList([]);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('buildingNumbers').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      buildingNumberList = tempData;
      // provider.setBuilderList(buildingNumberList);
    }
    setState(() {});
  }

  Future<void> getFloor() async {
    // final provider = Provider.of<AllFloorProvider>(context, listen: false);
    // provider.setBuilderList([]);

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('floorNumbers').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();

      uniqueFloorList.addAll(tempData);
      Set<String> set = uniqueFloorList.toSet();
      floorNumberList = set.toList();
      // provider.setBuilderList(floorNumberList);
    }

    print(floorNumberList);
    setState(() {});
  }

  Future<void> getRoom() async {
    List<String> uniqueRoomList = [];
    // final provider = Provider.of<AllRoomProvider>(context, listen: false);
    // provider.setBuilderList([]);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('roomNumbers').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      uniqueRoomList.addAll(tempData);
      Set<String> set = uniqueRoomList.toSet();
      roomNumberList = set.toList();
      // provider.setBuilderList(roomNumberList);
    }
    print(roomNumberList);
    setState(() {});
  }

  Future<void> getAsset() async {
    List<String> uniqueAssetsList = [];
    // final provider = Provider.of<AllAssetProvider>(context, listen: false);
    // provider.setBuilderList([]);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('assets').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      uniqueAssetsList.addAll(tempData);
      Set<String> set = uniqueAssetsList.toSet();
      assetList = set.toList();
      // provider.setBuilderList(assetList);
    }
    setState(() {});
  }

  Future<void> getWorkList() async {
    // final provider = Provider.of<AllWorkProvider>(context, listen: false);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('works').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      allWorkData = tempData;
    }

    // provider.setBuilderList(allWorkData);
    setState(() {});
  }

  Widget customDropDown(String title, List<String> customDropDownList,
      String hintText, int index) {
    return Card(
      elevation: 5.0,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            hintText,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          items: customDropDownList
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ))
              .toList(),
          value: index == 0
              ? selectedStartDate
              : index == 1
                  ? selectedTicket
                  : index == 2
                      ? selectedbuilding
                      : index == 3
                          ? selectedFloor
                          : index == 4
                              ? selectedRoom
                              : index == 5
                                  ? selectedUser
                                  : index == 6
                                      ? selectedAsset
                                      : index == 7
                                          ? selectedServiceProvider
                                          : index == 8
                                              ? selectedStatus
                                              : selectedWork,
          onChanged: (value) async {
            setState(() {
              index == 0
                  ? selectedStartDate = value!
                  : index == 1
                      ? selectedTicket = value
                      : index == 2
                          ? selectedbuilding = value
                          : index == 3
                              ? selectedFloor = value
                              : index == 4
                                  ? selectedRoom = value
                                  : index == 5
                                      ? selectedUser = value
                                      : index == 6
                                          ? selectedAsset = value
                                          : index == 7
                                              ? selectedServiceProvider = value
                                              : index == 8
                                                  ? selectedStatus = value
                                                  : selectedWork = value;
            });
            // await getFloor(selectedbuilding!).whenComplete(() {
            //   setState(() {
            //     getRoom(selectedbuilding!, selectedFloor!).whenComplete(() {
            //       setState(() {
            //         getAsset(selectedbuilding!, selectedFloor!, selectedRoom!);
            //       });
            //     });
            //   });
            // });
          },
          buttonStyleData: const ButtonStyleData(
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            width: 150,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: index == 0
                ? dateController
                : index == 1
                    ? ticketController
                    : index == 2
                        ? buildingController
                        : index == 3
                            ? floorController
                            : index == 4
                                ? roomController
                                : index == 5
                                    ? userController
                                    : index == 6
                                        ? assetController
                                        : index == 7
                                            ? serviceProviderController
                                            : index == 8
                                                ? statusController
                                                : workController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: index == 0
                    ? dateController
                    : index == 1
                        ? ticketController
                        : index == 2
                            ? buildingController
                            : index == 3
                                ? floorController
                                : index == 4
                                    ? roomController
                                    : index == 5
                                        ? userController
                                        : index == 6
                                            ? assetController
                                            : serviceProviderController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: hintText,
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().contains(searchValue);
            },
          ),
          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {}
          },
        ),
      ),
    );
  }

  Future<void> pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,

      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      saveText: "OK",
      // initialEntryMode: DatePickerEntryMode.input,
    );
    if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
      rangeStartDate = dateRange.start;
      rangeEndDate = dateRange.end;

      selectedStartDate = DateFormat('dd-MM-yyyy').format(rangeStartDate);
      // "${rangeStartDate.day.toString().padLeft(2, '0')}-${rangeStartDate.month.toString().padLeft(2, '0')}-${rangeStartDate.year.toString()} ";
      selectedEndDate = DateFormat('dd-MM-yyyy').format(rangeEndDate!);
      // "${rangeEndDate!.day.toString().padLeft(2, '0')}-${rangeEndDate!.month.toString().padLeft(2, '0')}-${rangeEndDate!.year.toString()} ";
    });
  }

  Future<void> filterTickets(String userID) async {
    // print('before $selectedUser');
    // selectedUser = selectedUser.toString().split(' ')[2];
    // print('selectedUse123r $selectedUser');
    try {
      filterData.clear();
      ticketList.clear();

      QuerySnapshot monthQuery =
          await FirebaseFirestore.instance.collection("raisedTickets").get();
      List<dynamic> dateList = monthQuery.docs.map((e) => e.id).toList();
      for (int i = 0; i < dateList.length; i++) {
        if (selectedStartDate.isNotEmpty && selectedEndDate.isNotEmpty) {
          for (int j = 0; j < dateList.length; j++) {
            List<dynamic> temp = [];
            QuerySnapshot ticketQuery = await FirebaseFirestore.instance
                .collection("raisedTickets")
                .doc(dateList[j])
                .collection('tickets')
                .where('date', isGreaterThanOrEqualTo: selectedStartDate)
                .where('date', isLessThanOrEqualTo: selectedEndDate)
                .get();

            temp = ticketQuery.docs.map((e) => e.id).toList();
            // ticketList = ticketList + temp;

            if (temp.isNotEmpty) {
              ticketList.addAll(temp);
              for (int k = 0; k < temp.length; k++) {
                DocumentSnapshot ticketDataQuery = await FirebaseFirestore
                    .instance
                    .collection("raisedTickets")
                    .doc(dateList[j])
                    .collection('tickets')
                    .doc(temp[k])
                    .get();
                if (ticketDataQuery.exists) {
                  Map<String, dynamic> mapData =
                      ticketDataQuery.data() as Map<String, dynamic>;
                  filterData.add(mapData);
                  // print('$mapData abc');
                }
              }
            }
          }
        } else {
          QuerySnapshot dateQuery = await FirebaseFirestore.instance
              .collection("raisedTickets")
              .get();
          List<dynamic> dateList = dateQuery.docs.map((e) => e.id).toList();
          for (int j = 0; j < dateList.length; j++) {
            List<dynamic> temp = [];
            Query query = FirebaseFirestore.instance
                .collection("raisedTickets")
                .doc(dateList[j])
                .collection('tickets');
            if (selectedStatus != null) {
              query = query.where('status', isEqualTo: selectedStatus);
            }
            if (selectedFloor != null) {
              query = query.where('floor', isEqualTo: selectedFloor);
            }
            if (selectedTicket != null) {
              query = query.where('tickets', isEqualTo: selectedTicket);
            }
            if (selectedRoom != null) {
              query = query.where('room', isEqualTo: selectedRoom);
            }
            if (selectedWork != null) {
              query = query.where('work', isEqualTo: selectedWork);
            }
            if (selectedAsset != null) {
              query = query.where('asset', isEqualTo: selectedAsset);
            }
            if (selectedbuilding != null) {
              query = query.where('building', isEqualTo: selectedbuilding);
            }
            if (selectedServiceProvider != null) {
              query = query.where('serviceProvider',
                  isEqualTo: selectedServiceProvider);
            }
            QuerySnapshot ticketQuery = await query.get();
          

            temp = ticketQuery.docs.map((e) => e.id).toList();
            // ticketList = ticketList + temp;
            print('Temp String $temp');

            if (temp.isNotEmpty) {
              ticketList = ticketList + temp;
              for (int k = 0; k < temp.length; k++) {
                DocumentSnapshot ticketDataQuery = await FirebaseFirestore
                    .instance
                    .collection("raisedTickets")
                    .doc(dateList[j])
                    .collection('tickets')
                    .doc(temp[k])
                    .get();
                if (ticketDataQuery.exists) {
                  Map<String, dynamic> mapData =
                      ticketDataQuery.data() as Map<String, dynamic>;

                  filterData.add(mapData);
                  print('$mapData abc');
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error Fetching tickets: $e");
    }
  }
}
