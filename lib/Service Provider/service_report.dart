// import 'package:flutter/material.dart';
// import 'package:ticket_management_system/Service%20Provider/service_filtererdReport.dart';

// class service_report extends StatefulWidget {
//   const service_report({super.key});

//   @override
//   State<service_report> createState() => _service_reportState();
// }

// class _service_reportState extends State<service_report> {
  
//   final List<String> serviceProviders = [
//     'Provider A',
//     'Provider B',
//     'Provider C',
//     'Provider D',
//   ];

//   String? _selectedServiceProvider;
//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('service_report'),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const ServiceReportScreen()),
//                 );
//               },
//               icon: const Icon(
//                 Icons.arrow_forward_ios_outlined,
//                 size: 35,
//               ))
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 Text(
//                   'Ticket #: 12345', // Display your ticket number here
//                   style: TextStyle(
//                     color: Colors.blue,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Status - Open',
//                   style: TextStyle(
//                     color: Colors.blue,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Card(
//               margin: const EdgeInsets.all(5,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const TextField(
//                       decoration: InputDecoration(hintText: 'Work'),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     const TextField(
//                       decoration: InputDecoration(hintText: 'Building'),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     const TextField(
//                       decoration: InputDecoration(hintText: 'Floor'),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     const TextField(
//                       decoration: InputDecoration(hintText: 'Room'),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     const TextField(
//                       decoration: InputDecoration(hintText: 'Asset'),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(5.0)),
//                       child: DropdownButtonFormField(
//                         value: _selectedServiceProvider,
//                         items: serviceProviders.map((String provider) {
//                           return DropdownMenuItem(
//                             value: provider,
//                             child: Text(provider),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedServiceProvider = value.toString();
//                           });
//                         },
//                         decoration: const InputDecoration(
//                           hintText: 'Service Provider',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _getCurrentDate(),
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getCurrentDate() {
//     DateTime now = DateTime.now();
//     return '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}';
//   }

//   String _addLeadingZero(int number) {
//     return number.toString().padLeft(2, '0');
//   }
// }
