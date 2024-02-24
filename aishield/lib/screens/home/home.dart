import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:reward_popup/reward_popup.dart';
import 'package:social_share/social_share.dart';
import 'package:web3dart/web3dart.dart';

import '../../constant.dart';
import '../../models/Detection.dart';
import '../../providers.dart';
import '../../services/secure_storage_service.dart';
import '../messages/SignIn/sign_in_page.dart';
import 'album_screen.dart';
import 'widgets/section_title.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _determinePosition();
      contractAddress();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  _topBanner() {
    return Container(
      height: 270,
      decoration: BoxDecoration(
        color: mainColor,
      ),
    );
  }

  /// Determine the current position of the device.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position _currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    ref.watch(latitudeProvider.notifier).state =
        _currentLocation.latitude.toString();

    ref.watch(longitudeProvider.notifier).state =
        _currentLocation.longitude.toString();

    return _currentLocation;
  }

  Future<void> contractAddress() async {
    final httpRpcUrl = "https://ethereum-sepolia.publicnode.com";
    final wsRpcUrl = "wss://ethereum-sepolia.publicnode.com";
    var httpClient = Client();
    EtherAmount balance;
    var ethClient = Web3Client(httpRpcUrl, httpClient);
    var currentPlatform = Theme.of(context).platform;
    LocalStorageService service = LocalStorageService(currentPlatform);
    var secureDataList = await service.readAllSecureData();
    var mnemonicGenerate = secureDataList?[5];

    final isValidMnemonic = bip39.validateMnemonic(mnemonicGenerate);
    if (!isValidMnemonic) {
      throw 'Invalid mnemonic';
    }
    String hdPath = "m/44'/60'/0'/0";
    final seed = bip39.mnemonicToSeed(mnemonicGenerate);
    final root = bip32.BIP32.fromSeed(seed);
    const first = 0;
    final firstChild = root.derivePath("$hdPath/$first");
    final privateKey = HEX.encode(firstChild.privateKey as List<int>);
    final credentials = EthPrivateKey.fromHex(privateKey);
    ref.watch(contractAddressProvider.notifier).state =
        credentials.address.toString();
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AlbumScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ref.watch(latitudeProvider).isEmpty &&
              ref.watch(longitudeProvider).isEmpty
          ? SafeArea(child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
                      _topBanner(),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 15,
                          top: 55,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Spacer(),
                                Container(
                                    child: IconButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignInPage()));
                                  },
                                  icon: Icon(Icons.logout),
                                  iconSize: 30,
                                  color: Colors.white,
                                )),
                              ],
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Gold Member",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.card_giftcard,
                                    color: Color(0XFFFFD700),
                                    size: 32,
                                  ),
                                ],
                              ),
                              onTap: () =>
                                  Navigator.push(context, _createRoute()),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                ref.watch(contractAddressProvider) ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: 150,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.wallet,
                                          color: mainColor,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "Report",
                                          style: TextStyle(
                                            color: mainColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () => Navigator.of(context)
                                      .pushNamed("/reportPage"),
                                ),
                                const SizedBox(width: 10),
                                StreamBuilder(
                                  stream: ref
                                      .read(databaseProvider)
                                      ?.getDetection(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return Text(
                                        snapshot.data!.length.toString() +
                                            " Reported",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.document_scanner,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      SectionTitle(title: "Risk Status"),
                      const SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Card(
                          color: Colors.white,
                          elevation: 8,
                          child: Container(
                            child: FlutterMap(
                              options: MapOptions(
                                  center: LatLng(
                                      double.parse(ref.watch(latitudeProvider)),
                                      double.parse(
                                          ref.watch(longitudeProvider))),
                                  zoom: 10.0),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://mt0.google.com/vt/lyrs=s&hl=en&x={x}&y={y}&z={z}&s=Ga',
                                ),
                                StreamBuilder(
                                    stream: ref
                                        .read(databaseProvider)!
                                        .getDetection(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      } else {
                                        return MarkerLayer(markers: [
                                          Marker(
                                            width: 30.0,
                                            height: 30.0,
                                            point: LatLng(
                                                double.parse(ref
                                                    .watch(latitudeProvider)),
                                                double.parse(ref
                                                    .watch(longitudeProvider))),
                                            child: Container(
                                              child: Container(
                                                child: Icon(
                                                  Icons.location_on,
                                                  color:
                                                      Colors.lightGreenAccent,
                                                  size: 40,
                                                ),
                                              ),
                                            ),
                                          ),
                                          for (int i = 0;
                                              i < snapshot.data!.length;
                                              i++)
                                            Marker(
                                              width: 30.0,
                                              height: 30.0,
                                              point: LatLng(
                                                  double.parse(snapshot
                                                      .data![i].latitude),
                                                  double.parse(snapshot
                                                      .data![i].longitude)),
                                              child: Container(
                                                child: Container(
                                                  child: Icon(
                                                    Icons.warning,
                                                    color: Colors.red,
                                                    size: 40,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ]);
                                      }
                                    })
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SectionTitle(
                        title: "Subscribe Now",
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/images/ESG.jpg",
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Malaysia’s ESG Trail: Paving the Way Forward",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Sponsored by AI Shield",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                "Offers you may interested ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Color(0xFFEBEBEB),
                              ),
                              child: Icon(
                                LineAwesomeIcons.arrow_right,
                                size: 15,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 100,
                        child: ListView.builder(
                          itemCount: 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(left: 10),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Image.asset(
                                "assets/images/food-coupons.jpg",
                                width: 200,
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
