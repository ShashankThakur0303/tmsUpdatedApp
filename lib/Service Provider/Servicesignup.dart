import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ticket_management_system/Service%20Provider/Servicelogin.dart';

class serviceSignup extends StatefulWidget {
  const serviceSignup({super.key});

  @override
  State<serviceSignup> createState() => _serviceSignupState();
}

class _serviceSignupState extends State<serviceSignup> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController serviceFirstController = TextEditingController();
  TextEditingController serviceLastController = TextEditingController();
  TextEditingController serviceMobileController = TextEditingController();
  TextEditingController servicePasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  String providerFirst = '';
  String providerLast = '';
  String providerMobile = '';
  String providerPassword = '';
  String errorMessage = '';

  @override
  void dispose() {
    serviceFirstController.dispose();
    serviceLastController.dispose();
    serviceMobileController.dispose();
    servicePasswordController.dispose();
  }

  double? height, width;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/service.png'),
                    backgroundColor: Colors.white,
                  ),
                ),
                const Text(
                  'C.M.S',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: serviceFirstController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                hintText: 'Enter your first name',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your first name";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: serviceLastController,
                              decoration: const InputDecoration(
                                labelText: 'last Name',
                                hintText: 'Enter your last name',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              maxLength: 10,
                              controller: serviceMobileController,
                              decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                hintText: 'Enter your mobile number',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your mobile number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: servicePasswordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            )
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await storeServiceData(
                                context,
                                serviceFirstController.text,
                                serviceLastController.text,
                                serviceMobileController.text,
                                servicePasswordController.text);
                          }
                        },
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 5),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginService()));
                      },
                      child: Text(
                        'Already have an account? Sign in',
                        style: TextStyle(fontSize: 15),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> storeServiceData(
      BuildContext context,
      String providerFirst,
      String providerLast,
      String providerMobile,
      String providerPassword) async {
    String firstInitial = providerFirst[0][0].trim().toUpperCase();
    String lastInitial = providerLast[0][0].trim().toUpperCase();
    String mobilelastFour = providerMobile.substring(providerMobile.length - 4);

    String serviceID = '$firstInitial$lastInitial$mobilelastFour';
    //  String fullName = '$providerFirst $providerLast';

    try {
      await firestore.collection('ServiceProviders').doc(serviceID).set({
        'First Name': providerFirst,
        'Last Name': providerLast,
        'Mobile No': providerMobile,
        'password': providerPassword,
      });

      // await firestore.collection('ServiceProviders').doc(fullName).set({
      //   'First Name': providerFirst,
      //   'Last Name': providerLast,
      //   'position':
      // });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return LoginService();
        }),
        (route) => false,
      );

      setState(() {
        errorMessage = '';
      });
    } on FirebaseException catch (e) {
      setState(() {
        errorMessage = e.message!;
      });
    }
  }
}
