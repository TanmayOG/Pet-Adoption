import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  var name = TextEditingController();
  String currentAddress = 'My Address';
  Position? currentposition;
  String? locality = 'My Locality';
  String? subLocality = 'My SubLocality';
  String? subAdminArea = 'My SubAdminArea';
  String? postalCode = 'My PostalCode';
  double? long = 0.0;
  double? lat = 0.0;
  var city = TextEditingController();

  // CollectionReference adoption =
  //     FirebaseFirestore.instance.collection('Adoption');
  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentposition = position;
        locality = place.locality;
        subLocality = place.subLocality;
        subAdminArea = place.subAdministrativeArea;
        postalCode = place.postalCode;
        long = position.longitude;
        lat = position.latitude;
        // currentAddress = '${place}';
        currentAddress =
            '${place.name} , ${place.street} ${place.locality}  , ${place.subAdministrativeArea}, ${place.administrativeArea} , ${place.country}, ${place.postalCode}';
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Could not get address');
    }
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            'User Details',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Fill the details below to get started',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[600]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo[100]),
                    child: TextField(
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      controller: name,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                        hintText: 'Enter Your Name',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo[100]),
                    child: TextField(
                      controller: city,
                      maxLines: 5,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () async {
                              city.text = "Locating....";
                              await _determinePosition().then((value) {
                                if (currentAddress != null) {
                                  setState(() {
                                    city.text = currentAddress;
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Please Enable Location Service');
                                }
                              });
                            },
                            icon: const Icon(Icons.location_on)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                        hintText: 'Enter City Name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ignore: deprecated_member_use
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.indigo[400],
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                        bottom: MediaQuery.of(context).size.height * 0.01,
                        left: MediaQuery.of(context).size.width * 0.08,
                        right: MediaQuery.of(context).size.width * 0.08),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
