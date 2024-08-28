import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/Homescreen.dart';
import 'package:ticket_management_system/Service%20Provider/service_home.dart';

class spliScreen extends StatefulWidget {
  spliScreen({super.key, required this.userID});
  String userID;

  @override
  State<spliScreen> createState() => _spliScreenState();
}

class _spliScreenState extends State<spliScreen> {
  @override
  void initState() {
    print('ddsdssss ${widget.userID}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            userID: widget.userID,
                          )));
            },
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width * 0.5,
                color: Color.fromARGB(255, 197, 66, 73),
                alignment: Alignment.center,
                margin: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 60,
                    ),
                    Text(
                      "User",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Homeservice(
                            userID: widget.userID,
                          )));
            },
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: MediaQuery.of(context).size.width * 0.5,
                  color: Color.fromARGB(255, 141, 36, 41),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(
                        Icons.webhook_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                      Text(
                        'Service Provider',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
