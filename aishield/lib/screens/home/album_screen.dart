import 'dart:math';

import 'package:aishield/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashlib/hashlib.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:reward_popup/reward_popup.dart';

import '../../constant.dart';
import '../../services/secure_storage_service.dart';

class AlbumScreen extends ConsumerStatefulWidget {
  AlbumScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends ConsumerState<AlbumScreen> {
  @override
  _topBanner() {
    return Container(
      // padding: EdgeInsets.all(15.0),
      height: 300,
      decoration: BoxDecoration(
        color: mainColor,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _readRewards();
    });
  }

  Future<void> _readRewards() async {
    var currentPlatform = Theme.of(context).platform;
    LocalStorageService service = LocalStorageService(currentPlatform);
    var secureDataList = await service.readAllSecureData();
    var storageRewards = secureDataList?[6];
    List<String> rewardsList = storageRewards.split(", ");
    // print(rewardsList);
    ref.watch(reward1Provider.notifier).state = double.parse(rewardsList[0]);
    ref.watch(reward2Provider.notifier).state = double.parse(rewardsList[1]);
    ref.watch(reward3Provider.notifier).state = double.parse(rewardsList[2]);
    ref.watch(reward4Provider.notifier).state = double.parse(rewardsList[3]);
    ref.watch(numberAlbumProvider.notifier).state =
        int.parse(secureDataList?[7]);
    ref.watch(completedAlbumProvider.notifier).state =
        int.parse(secureDataList?[8]);
    ref.watch(dataLengthProvider.notifier).state =
        int.parse(secureDataList?[9]);
    ref.watch(chanceProvider.notifier).state = int.parse(secureDataList?[10]);
    print(ref.watch(chanceProvider));
    var detectionCount = await ref.read(databaseProvider)!.getDetectionCount();
  }

  dynamic imagesList = [
    "assets/images/carbon.png",
    "assets/images/airpollution.jpeg",
    "assets/images/renewable.jpeg",
    "assets/images/biodiversity.png"
  ];
  final random = new Random();

  Widget build(BuildContext context) {
    var detection = ref.read(databaseProvider)!.getDetection();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "ESG Album Collection",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.collections,
                            color: Colors.white,
                            size: 32,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          ref.watch(numberAlbumProvider).toString() + "/4",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: 180,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: ref.watch(chanceProvider) <= 0
                                    ? Colors.grey.shade500
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.redeem,
                                    color: mainColor,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Redeem Now",
                                    style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: ref.watch(chanceProvider) <= 0
                                ? null
                                : () async {
                                    var randomImage = imagesList[
                                        random.nextInt(imagesList.length)];
                                    ref.watch(chanceProvider.notifier).state -=
                                        1;
                                    for (var i = 0;
                                        i < imagesList.length;
                                        i++) {
                                      if (randomImage == imagesList[i]) {
                                        if (i == 0) {
                                          if (ref.watch(reward1Provider) >=
                                              1.00) {
                                            print("Try Again Next Time");
                                          } else {
                                            ref
                                                .watch(reward1Provider.notifier)
                                                .state += 0.25;
                                            if (ref.watch(reward1Provider) >=
                                                1.00) {
                                              ref
                                                  .watch(numberAlbumProvider
                                                      .notifier)
                                                  .state += 1;
                                            }
                                            //Store the data into a secure local storage with the following parameters
                                            var currentPlatform =
                                                Theme.of(context).platform;
                                            LocalStorageService service =
                                                LocalStorageService(
                                                    currentPlatform);
                                            var secureDataList = await service
                                                .readAllSecureData();

                                            var storage = LocalStorage(
                                              categories: "password",
                                              value: secureDataList?[0],
                                              mac: secureDataList?[3],
                                              mnemonicSeed: secureDataList?[5],
                                              mnemonicEntropy:
                                                  secureDataList?[1],
                                              keyHex: secureDataList?[2],
                                              keyPair: secureDataList?[4],
                                              rewards:
                                                  "${ref.watch(reward1Provider)}, ${ref.watch(reward2Provider)}, ${ref.watch(reward3Provider)}, ${ref.watch(reward4Provider)}",
                                              rewardCompleted: ref
                                                  .watch(numberAlbumProvider),
                                              albumCompleted: ref.watch(
                                                  completedAlbumProvider),
                                              dataLength:
                                                  ref.watch(dataLengthProvider),
                                              chance: ref.watch(chanceProvider),
                                            );
                                            service.writeData(storage);
                                          }
                                        } else if (i == 1) {
                                          if (ref.watch(reward2Provider) >=
                                              1.00) {
                                            print("Try Again Next Time");
                                          } else {
                                            ref
                                                .watch(reward2Provider.notifier)
                                                .state += 0.25;

                                            if (ref.watch(reward2Provider) >=
                                                1.00) {
                                              ref
                                                  .watch(numberAlbumProvider
                                                      .notifier)
                                                  .state += 1;
                                            }
                                            var currentPlatform =
                                                Theme.of(context).platform;
                                            LocalStorageService service =
                                                LocalStorageService(
                                                    currentPlatform);
                                            var secureDataList = await service
                                                .readAllSecureData();

                                            var storage = LocalStorage(
                                              categories: "password",
                                              value: secureDataList?[0],
                                              mac: secureDataList?[3],
                                              mnemonicSeed: secureDataList?[5],
                                              mnemonicEntropy:
                                                  secureDataList?[1],
                                              keyHex: secureDataList?[2],
                                              keyPair: secureDataList?[4],
                                              rewards:
                                                  "${ref.watch(reward1Provider)}, ${ref.watch(reward2Provider)}, ${ref.watch(reward3Provider)}, ${ref.watch(reward4Provider)}",
                                              rewardCompleted: ref
                                                  .watch(numberAlbumProvider),
                                              albumCompleted: ref.watch(
                                                  completedAlbumProvider),
                                              dataLength:
                                                  ref.watch(dataLengthProvider),
                                              chance: ref.watch(chanceProvider),
                                            );
                                            service.writeData(storage);
                                          }
                                        } else if (i == 2) {
                                          if (ref.watch(reward3Provider) >=
                                              1.00) {
                                            print("Try Again Next Time");
                                          } else {
                                            ref
                                                .watch(reward3Provider.notifier)
                                                .state += 0.25;
                                            if (ref.watch(reward3Provider) >=
                                                1.00) {
                                              ref
                                                  .watch(numberAlbumProvider
                                                      .notifier)
                                                  .state += 1;
                                            }
                                            var currentPlatform =
                                                Theme.of(context).platform;
                                            LocalStorageService service =
                                                LocalStorageService(
                                                    currentPlatform);
                                            var secureDataList = await service
                                                .readAllSecureData();

                                            var storage = LocalStorage(
                                              categories: "password",
                                              value: secureDataList?[0],
                                              mac: secureDataList?[3],
                                              mnemonicSeed: secureDataList?[5],
                                              mnemonicEntropy:
                                                  secureDataList?[1],
                                              keyHex: secureDataList?[2],
                                              keyPair: secureDataList?[4],
                                              rewards:
                                                  "${ref.watch(reward1Provider)}, ${ref.watch(reward2Provider)}, ${ref.watch(reward3Provider)}, ${ref.watch(reward4Provider)}",
                                              rewardCompleted: ref
                                                  .watch(numberAlbumProvider),
                                              albumCompleted: ref.watch(
                                                  completedAlbumProvider),
                                              dataLength:
                                                  ref.watch(dataLengthProvider),
                                              chance: ref.watch(chanceProvider),
                                            );
                                            service.writeData(storage);
                                          }
                                        } else if (i == 3) {
                                          if (ref.watch(reward4Provider) >=
                                              1.00) {
                                            print("Try Again Next Time");
                                          } else {
                                            ref
                                                .watch(reward4Provider.notifier)
                                                .state += 0.25;
                                            if (ref.watch(reward4Provider) >=
                                                1.00) {
                                              ref
                                                  .watch(numberAlbumProvider
                                                      .notifier)
                                                  .state += 1;
                                            }
                                            var currentPlatform =
                                                Theme.of(context).platform;
                                            LocalStorageService service =
                                                LocalStorageService(
                                                    currentPlatform);
                                            var secureDataList = await service
                                                .readAllSecureData();

                                            var storage = LocalStorage(
                                              categories: "password",
                                              value: secureDataList?[0],
                                              mac: secureDataList?[3],
                                              mnemonicSeed: secureDataList?[5],
                                              mnemonicEntropy:
                                                  secureDataList?[1],
                                              keyHex: secureDataList?[2],
                                              keyPair: secureDataList?[4],
                                              rewards:
                                                  "${ref.watch(reward1Provider)}, ${ref.watch(reward2Provider)}, ${ref.watch(reward3Provider)}, ${ref.watch(reward4Provider)}",
                                              rewardCompleted: ref
                                                  .watch(numberAlbumProvider),
                                              albumCompleted: ref.watch(
                                                  completedAlbumProvider),
                                              dataLength:
                                                  ref.watch(dataLengthProvider),
                                              chance: ref.watch(chanceProvider),
                                            );
                                            service.writeData(storage);
                                          }
                                        }
                                      }
                                      if (ref
                                              .watch(
                                                  numberAlbumProvider.notifier)
                                              .state >=
                                          4) {
                                        ref
                                            .watch(numberAlbumProvider.notifier)
                                            .state = 0;
                                        var currentPlatform =
                                            Theme.of(context).platform;
                                        LocalStorageService service =
                                            LocalStorageService(
                                                currentPlatform);
                                        var secureDataList =
                                            await service.readAllSecureData();
                                        ref
                                            .watch(
                                                completedAlbumProvider.notifier)
                                            .state += 1;
                                        var storage = LocalStorage(
                                            categories: "password",
                                            value: secureDataList?[0],
                                            mac: secureDataList?[3],
                                            mnemonicSeed: secureDataList?[5],
                                            mnemonicEntropy: secureDataList?[1],
                                            keyHex: secureDataList?[2],
                                            keyPair: secureDataList?[4],
                                            rewards:
                                                "${ref.watch(reward1Provider)}, ${ref.watch(reward2Provider)}, ${ref.watch(reward3Provider)}, ${ref.watch(reward4Provider)}",
                                            rewardCompleted:
                                                ref.watch(numberAlbumProvider),
                                            albumCompleted: ref
                                                .watch(completedAlbumProvider));
                                        ref
                                            .watch(reward1Provider.notifier)
                                            .state = 0.0;
                                        ref
                                            .watch(reward2Provider.notifier)
                                            .state = 0.0;
                                        ref
                                            .watch(reward3Provider.notifier)
                                            .state = 0.0;
                                        ref
                                            .watch(reward4Provider.notifier)
                                            .state = 0.0;
                                      }
                                    }

                                    final answer =
                                        await showRewardPopup<String>(
                                      context,
                                      backgroundColor: Colors.black,
                                      child: Positioned.fill(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Image.asset(
                                            randomImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        child: Text(
                          "Remaining Chance: ${ref.watch(chanceProvider)}",
                          style: TextStyle(
                            decorationThickness: 1,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                    top: 230,
                    right: 10,
                    left: 10,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      elevation: 8,
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(15),
                              child: Row(children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/carbon.png"),
                                        radius: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Climate Change \n& Carbon Emission ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(15),
                                      animation: true,
                                      width: 150,
                                      lineHeight: 25,
                                      percent: ref.watch(reward1Provider),
                                      center: Text(
                                        ref.watch(reward1Provider) == 0.0
                                            ? "0/4"
                                            : ref.watch(reward1Provider) == 0.25
                                                ? "1/4"
                                                : ref.watch(reward1Provider) ==
                                                        0.5
                                                    ? "2/4"
                                                    : ref.watch(reward1Provider) ==
                                                            0.75
                                                        ? "3/4"
                                                        : ref.watch(reward1Provider) ==
                                                                1.00
                                                            ? "4/4"
                                                            : "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey,
                                      progressColor: mainColor,
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/airpollution.jpeg"),
                                        radius: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Air & Water\n Pollution ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(15),
                                      animation: true,
                                      width: 150,
                                      lineHeight: 25,
                                      percent: ref.watch(reward2Provider),
                                      center: Text(
                                        ref.watch(reward2Provider) == 0.0
                                            ? "0/4"
                                            : ref.watch(reward2Provider) == 0.25
                                                ? "1/4"
                                                : ref.watch(reward2Provider) ==
                                                        0.5
                                                    ? "2/4"
                                                    : ref.watch(reward2Provider) ==
                                                            0.75
                                                        ? "3/4"
                                                        : ref.watch(reward2Provider) ==
                                                                1.00
                                                            ? "4/4"
                                                            : "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey,
                                      progressColor: mainColor,
                                    )
                                  ],
                                ),
                              ])),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(20),
                              child: Row(children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/renewable.jpeg"),
                                        radius: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Renewable Energy \n(Solar)",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(15),
                                      animation: true,
                                      width: 150,
                                      lineHeight: 25,
                                      percent: ref.watch(reward3Provider),
                                      center: Text(
                                        ref.watch(reward3Provider) == 0.0
                                            ? "0/4"
                                            : ref.watch(reward3Provider) == 0.25
                                                ? "1/4"
                                                : ref.watch(reward3Provider) ==
                                                        0.5
                                                    ? "2/4"
                                                    : ref.watch(reward3Provider) ==
                                                            0.75
                                                        ? "3/4"
                                                        : ref.watch(reward3Provider) ==
                                                                1.00
                                                            ? "4/4"
                                                            : "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey,
                                      progressColor: mainColor,
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/biodiversity.png"),
                                        radius: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Biodiversity\n Ecosystem",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(15),
                                      animation: true,
                                      width: 150,
                                      lineHeight: 25,
                                      percent: ref.watch(reward4Provider),
                                      center: Text(
                                        ref.watch(reward4Provider) == 0.0
                                            ? "0/4"
                                            : ref.watch(reward4Provider) == 0.25
                                                ? "1/4"
                                                : ref.watch(reward4Provider) ==
                                                        0.5
                                                    ? "2/4"
                                                    : ref.watch(reward4Provider) ==
                                                            0.75
                                                        ? "3/4"
                                                        : ref.watch(reward4Provider) ==
                                                                1.00
                                                            ? "4/4"
                                                            : "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey,
                                      progressColor: mainColor,
                                    )
                                  ],
                                ),
                              ])),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                top: 2,
                right: 15,
                left: 15,
              ),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
