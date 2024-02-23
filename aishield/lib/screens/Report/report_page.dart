import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../constant.dart';
import '../../models/Detection.dart';
import '../../providers.dart';
import '../../utils/snackbars.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      // debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      // debugPrint(e);
    });
  }

  List selection = [
    {"flag": false, "title": "Flood", "icon": Icons.flood},
    {"flag": false, "title": "Fire", "icon": Icons.fire_truck},
    {"flag": false, "title": "Accidents", "icon": Icons.car_crash},
    {"flag": false, "title": "Potholes", "icon": Icons.circle}
  ];
  bool? isSubmitButton;
  @override
  Widget build(BuildContext context) {
    _getCurrentPosition();
    _addReport(selectedItem) async {
      final storage = ref.read(databaseProvider);
      final fileStorage = ref.read(storageProvider); // reference file storage
      final imageFile =
          ref.read(addImageProvider.state).state; // referece the image File
      print("File");
      print(fileStorage);
      if (storage == null || fileStorage == null || imageFile == null) {
        // make sure none of them are null

        print("Error: storage, fileStorage or imageFile is null");
        return;
      }
      // Upload to Filestorage
      final imageUrl = await fileStorage.uploadFile(
        // upload File using our
        imageFile.path,
      );
      var timeNow = DateTime.now();
      var formatedDate =
          DateFormat('kk:mm:ss - yyyy-MM-dd (EEE)').format(timeNow);
      await storage.addReport(Detection(
        address: ref.watch(contractAddressProvider),
        timestamp: formatedDate,
        selection: selectedItem,
        imageUrl: imageUrl,
        latitude: '${_currentPosition?.latitude ?? ""}',
        longitude: '${_currentPosition?.longitude ?? ""}',
      ));
      Timer(Duration(milliseconds: 300), () {
        print(ref.watch(databaseProvider)?.docId);
      });

      //
      openIconSnackBar(
        context,
        "Report has been submitted",
        const Icon(Icons.check, color: Colors.white),
      );
      Timer(Duration(milliseconds: 300), () {
        Navigator.pop(context);
      });
    }

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Center(
        child: Column(
          children: [
            // Container(
            //   child: Image.asset(
            //     "assets/images/fire2.jpg",
            //     fit: BoxFit.fill,
            //   ),
            // ),
            Consumer(
              builder: (context, watch, child) {
                final image = ref.watch(addImageProvider);
                return image == null
                    ? Column(
                        children: [
                          Container(
                            child: Lottie.asset(
                              "assets/animations/image.json",
                              width: 350,
                              height: 300,
                            ),
                          ),
                          Text(
                            "No Image Selected",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : ref.watch(submitButtonProvider) == false
                        ? Container(
                            child: Image.file(
                            File(image.path),
                            width: 350,
                            height: 300,
                          ))
                        : Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.1,
                              bottom: MediaQuery.of(context).size.height * 0.1,
                            ),
                            child: CircularProgressIndicator(),
                          );
              },
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                selection.length,
                (index) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                        height: 85,
                        width: 85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey.shade200,
                          border: Border.all(
                            color: selection[index]["flag"]
                                ? mainColor
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        // color: Colors.grey.shade100,
                        padding: EdgeInsets.all(10.0),
                        child: GestureDetector(
                          child: Icon(
                            selection[index]["icon"],
                            size: 60,
                            color: mainColor.withOpacity(0.8),
                          ),
                          onTap: () {
                            setState(() {
                              selection[index]["flag"] =
                                  !selection[index]["flag"];
                              print(selection[index]["flag"]);
                              for (var x in selection) {
                                if (x["title"] != selection[index]["title"])
                                  x["flag"] = false;
                                isSubmitButton = false;
                                for (var x in selection) {
                                  if (x["flag"] == true) {
                                    isSubmitButton = true;
                                  }
                                }
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0, left: 15.0),
                        child: Text(
                          selection[index]["title"],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            Container(
              height: 60,
              width: 400,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSubmitButton == true ||
                          ref.watch(addImageProvider) == null
                      ? mainColor
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: ref.watch(addImageProvider) == null
                    ? Icon(Icons.upload_file)
                    : Icon(
                        Icons.check,
                      ),
                onPressed: ref.watch(addImageProvider) == null
                    ? () async {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (image != null) {
                          ref.watch(addImageProvider.notifier).state = image;
                        }
                      }
                    : isSubmitButton == false
                        ? () => null
                        : () async {
                            ref.watch(submitButtonProvider.notifier).state =
                                true;
                            var selectedItemName;
                            for (var x in selection) {
                              if (x["flag"] == true) {
                                selectedItemName = x["title"];
                              }
                            }
                            await _addReport(selectedItemName);
                            var docId = ref.watch(databaseProvider)?.docId;
                            print(docId);
                            if (docId != null || docId != "") {
                              var test = ref
                                  .watch(databaseProvider)
                                  ?.getDetectionInfo(docId ?? "");
                              test?.then((value) => ref
                                  .watch(detectionImageProvider.notifier)
                                  .state = value?.detectionImageUrl);
                              print(ref.watch(detectionImageProvider));
                            } else {
                              print("docId is null");
                            }
                          },
                label: ref.watch(addImageProvider) == null
                    ? Text(
                        "Take Picture Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    : Text(
                        "Submit Report",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            ref.watch(submitButtonProvider)
                ? Container(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Thank you for your reporting. We will update your report in history soon.',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  final detectionImageProvider = StateProvider<String?>((ref) => "");
  final submitButtonProvider = StateProvider<bool>((ref) => false);
  final addImageProvider = StateProvider<XFile?>((_) => null);
}
