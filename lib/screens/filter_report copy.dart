import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticket_management_system/screens/display_report.dart';

class FilteredReport extends StatefulWidget {
  const FilteredReport({super.key});

  @override
  State<FilteredReport> createState() => _FilteredReportState();
}

class _FilteredReportState extends State<FilteredReport> {
  List<dynamic> filterData = [];
  final tickerNumController = TextEditingController();
  final bldgController = TextEditingController();
  final assetController = TextEditingController();
  final floorController = TextEditingController();
  final serviceProviderController = TextEditingController();
  final roomController = TextEditingController();
  final statusController = TextEditingController();
  final workController = TextEditingController();

  List<String> buildings = [];
  List<String> selectedBuildings = [];
  List<String> assets = [];
  List<String> floors = [];
  List<String> rooms = [];
  List<String> works = [];
  List<String> serviceProviders = [];
  List<String> status = ["All", "Open", "Close"];

  String? selectedBuilding;
  String? selectedFloor;
  String? selectedRoom;
  String? selectedAsset;
  String? selectedWork;
  String? selectedStatus;
  String? selectedServiceProvider;
  bool isLoading = true;
  String? _selectDate;
  List<dynamic> ticketList = [];

  @override
  void initState() {
    getBuilding().whenComplete(() {
      getFloor().whenComplete(() {
        getRoom().whenComplete(() {
          getAsset().whenComplete(() {
            getWorks().whenComplete(() {
              isLoading = false;
              setState(() {});
            });
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tickets Report'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                             
                            },
                            child: const Text(
                              "Select Date",
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: TextField(
                        controller: tickerNumController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Search Ticket Number',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          contentPadding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField(
                              value: selectedBuilding,
                              items: buildings.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                selectedBuilding = value;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Buildings',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            //     DropdownButtonHideUnderline(
                            //   child: DropdownButton2<String>(
                            //     isExpanded: true,
                            //     hint: Text(
                            //       'Select Building',
                            //       style: TextStyle(
                            //         fontSize: 14,
                            //         color: Theme.of(context).hintColor,
                            //       ),
                            //     ),
                            //     items: floors.map((item) {
                            //       return DropdownMenuItem(
                            //         value: item,
                            //         //disable default onTap to avoid closing menu when selecting an item
                            //         enabled: false,
                            //         child: StatefulBuilder(
                            //           builder: (context, menuSetState) {
                            //             final isSelected =
                            //                 selectedBuildings.contains(item);
                            //             return InkWell(
                            //               onTap: () {
                            //                 isSelected
                            //                     ? selectedBuildings.remove(item)
                            //                     : selectedBuildings.add(item);
                            //                 //This rebuilds the StatefulWidget to update the button's text
                            //                 setState(() {});
                            //                 //This rebuilds the dropdownMenu Widget to update the check mark
                            //                 menuSetState(() {});
                            //               },
                            //               child: Container(
                            //                 height: double.infinity,
                            //                 padding: const EdgeInsets.symmetric(
                            //                     horizontal: 16.0),
                            //                 child: Row(
                            //                   children: [
                            //                     if (isSelected)
                            //                       const Icon(
                            //                           Icons.check_box_outlined)
                            //                     else
                            //                       const Icon(Icons
                            //                           .check_box_outline_blank),
                            //                     const SizedBox(width: 16),
                            //                     Expanded(
                            //                       child: Text(
                            //                         item,
                            //                         style: const TextStyle(
                            //                           fontSize: 14,
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             );
                            //           },
                            //         ),
                            //       );
                            //     }).toList(),
                            //     //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                            //     value: selectedBuildings.isEmpty
                            //         ? null
                            //         : selectedBuildings.last,
                            //     onChanged: (value) {
                            //       selectedBuilding = value;
                            //       setState(() {});
                            //     },
                            //     onMenuStateChange: (isOpen) {
                            //       if (!isOpen) {}
                            //     },
                            //     selectedItemBuilder: (context) {
                            //       return buildings.map(
                            //         (item) {
                            //           return Container(
                            //             alignment: AlignmentDirectional.center,
                            //             child: Text(
                            //               selectedBuildings.join(', '),
                            //               style: const TextStyle(
                            //                 fontSize: 14,
                            //                 overflow: TextOverflow.ellipsis,
                            //               ),
                            //               maxLines: 1,
                            //             ),
                            //           );
                            //         },
                            //       ).toList();
                            //     },
                            //     buttonStyleData: const ButtonStyleData(
                            //         padding:
                            //             EdgeInsets.only(left: 16, right: 8),
                            //         height: 60,
                            //         width: 140,
                            //         decoration: BoxDecoration(
                            //             border: Border(
                            //                 bottom:
                            //                     BorderSide(color: Colors.grey),
                            //                 top: BorderSide(color: Colors.grey),
                            //                 left:
                            //                     BorderSide(color: Colors.grey),
                            //                 right: BorderSide(
                            //                     color: Colors.grey)))),
                            //     menuItemStyleData: const MenuItemStyleData(
                            //       height: 40,
                            //       padding: EdgeInsets.zero,
                            //     ),
                            //   ),
                            // ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField(
                              value: selectedWork,
                              items: works.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                works.clear;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Work',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField(
                              value: selectedFloor,
                              // hint: const Text("Floor"),
                              //disabledHint: const Text("Select building first"),
                              items: floors.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                selectedFloor = value;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Floors',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField(
                              value: selectedServiceProvider,
                              items: serviceProviders.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                selectedServiceProvider = value;
                                getServiceProvider().whenComplete(
                                  () {
                                    setState(() {});
                                  },
                                );
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Service Provider',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownButtonFormField(
                            items: rooms.map((String option) {
                              return DropdownMenuItem(
                                  value: option, child: Text(option));
                            }).toList(),
                            onChanged: (value) async {
                              selectedRoom = value;
                            },
                            decoration: InputDecoration(
                                labelText: 'Rooms',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField(
                              value: selectedStatus,
                              items: status.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                status.clear;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField(
                              value: selectedAsset,
                              items: assets.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Assets',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.deepPurple,
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 32, vertical: 16),
                    //   ),
                    //   onPressed: () {
                    //     filterTickets(_selectDate ?? '').whenComplete(() {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => displayReport(
                    //                     ticketList: ticketList,
                    //                     ticketData: filterData,
                    //                   )));
                    //     });
                    //   },
                    //   child: const Text('Apply Filter'),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> getBuilding() async {
    // final provider = Provider.of<AllBuildingProvider>(context, listen: false);
    // provider.setBuilderList([]);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('buildingNumbers').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      buildings = tempData;
      // provider.setBuilderList(buildings);
    }
    print('buildings $buildings');
    setState(() {});
  }

  Future<void> getFloor() async {
    List<String> uniqueFloorList = [];
    for (var i = 0; i < buildings.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('buildingNumbers')
          .doc(buildings[i])
          .collection('floorNumbers')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();

        uniqueFloorList.addAll(tempData);
        Set<String> set = uniqueFloorList.toSet();
        floors = set.toList();
        // provider.setBuilderList(floors);
      }
    }
    print(floors);
    setState(() {});
  }

  Future<void> getRoom() async {
    List<String> uniqueRoomList = [];
    // final provider = Provider.of<AllRoomProvider>(context, listen: false);
    // provider.setBuilderList([]);
    for (var i = 0; i < buildings.length; i++) {
      for (var j = 0; j < floors.length; j++) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('buildingNumbers')
            .doc(buildings[i])
            .collection('floorNumbers')
            .doc(floors[j])
            .collection('roomNumbers')
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
          uniqueRoomList.addAll(tempData);
          Set<String> set = uniqueRoomList.toSet();
          rooms = set.toList();
          // provider.setBuilderList(rooms);
        }
      }
    }
    print(rooms);
    setState(() {});
  }

  Future<void> getAsset() async {
    List<String> uniqueAssetsList = [];
    // final provider = Provider.of<AllAssetProvider>(context, listen: false);
    // provider.setBuilderList([]);
    for (var i = 0; i < buildings.length; i++) {
      for (var j = 0; j < floors.length; j++) {
        for (var k = 0; k < rooms.length; k++) {
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('buildingNumbers')
              .doc(buildings[i])
              .collection('floorNumbers')
              .doc(floors[j])
              .collection('roomNumbers')
              .doc(rooms[k])
              .collection('assets')
              .get();
          if (querySnapshot.docs.isNotEmpty) {
            List<String> tempData =
                querySnapshot.docs.map((e) => e.id).toList();
            uniqueAssetsList.addAll(tempData);
            Set<String> set = uniqueAssetsList.toSet();
            assets = set.toList();
            // provider.setBuilderList(assetList);
          }
        }
      }
    }
    setState(() {});
  }

  Future getWorks() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('works').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      works = tempData;
    }

    // provider.setBuilderList(allWorkData);
    setState(() {});
  }

  Future getServiceProvider() async {
    List<dynamic> userList = [];
    QuerySnapshot serviceProviderQuery = await FirebaseFirestore.instance
        .collection("members")
        .where("role", isNotEqualTo: null)
        .get();
    if (serviceProviderQuery.docs.isNotEmpty) {
      userList = serviceProviderQuery.docs.map((e) => e.id).toList();
    }
    for (var i = 0; i < userList.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("members")
          .doc(userList[i])
          .get();
      if (documentSnapshot.data() != null) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        serviceProviders.add(data['fullName']);
      }
    }
  }

  Future<void> filterTickets(String selectedDate) async {
    try {
      

      Query query = FirebaseFirestore.instance
          .collection('raisedTickets')
          
          .doc(selectedDate)
          .collection('tickets');

      if (selectedBuilding != null) {
        query = query.where('building', isEqualTo: selectedBuilding.toString());
      }
      if (selectedAsset != null && selectedBuilding != null) {
        query = query.where('asset', isEqualTo: selectedAsset.toString());
      }
      if (selectedFloor != null) {
        query = query.where('floor', isEqualTo: selectedFloor.toString());
      }
      if (selectedServiceProvider != null) {
        query = query.where('serviceProvider',
            isEqualTo: selectedServiceProvider.toString());
      }
      if (selectedRoom != null) {
        query = query.where('room', isEqualTo: selectedRoom.toString());
      }
      if (selectedStatus != null) {
        query.where('status', isEqualTo: selectedStatus.toString());
      }
      if (selectedWork != null) {
        query.where('work', isEqualTo: selectedWork.toString());
      }

      QuerySnapshot filterQuery = await query.get();
      ticketList = filterQuery.docs.map((e) => e.id).toList();

      filterData = filterQuery.docs.map((e) => e.data()).toList();
      print("FilterData : $filterData");
      print(ticketList);
    } catch (e) {
      print("Error Occured While Filtering Data");
    }
  }

  

  Future<void> fetchAsset() async {
    QuerySnapshot callAssetQuery =
        await FirebaseFirestore.instance.collection('assets').get();
    List<dynamic> buildingList = callAssetQuery.docs.map((e) => e.id).toList();
    for (int i = 0; i < buildingList.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('assets')
          .doc(buildingList[i])
          .get();
      Map<String, dynamic> docData =
          documentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> assetList = docData['assets'];
      List<String> temp =
          List.generate(assetList.length, (index) => assetList[index]);
      assets = assets + temp;
    }
  }
}

Future<void> fetchFloor() async {
  QuerySnapshot callFloorQuery =
      await FirebaseFirestore.instance.collection('floors').get();
}
