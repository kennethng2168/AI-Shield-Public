import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';

import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:web3dart/crypto.dart';
import '../../../constant.dart';
import '../../../providers.dart';
import '../../../services/secure_storage_service.dart';
import 'package:encrypt/encrypt.dart' as encryptLib;

import '../../main/main_screen.dart';

class RecoveryPage extends ConsumerStatefulWidget {
  RecoveryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RecoveryPage> createState() => _RecoveryPageFormState();
}

class _RecoveryPageFormState extends ConsumerState<RecoveryPage> {
  @override
  // final LocalStorageService _localStorageService = LocalStorageService();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void initState() {
    super.initState();

    // var _items = await _localStorageService.readAllSecureData();
    // print(_items);
  }

  bool passwordNotFound = false;

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;

    LocalStorageService service = LocalStorageService(currentPlatform);
    var secureDataList = service.readAllSecureData();
    secureDataList.then((value) {
      List<int> bytesEntropy = hex.decode(value?[1]);
      // print(bytesEntropy);
      var mnemonic = Mnemonic(bytesEntropy, Language.english);

      // print(mnemonic3.seed);
      // print(mnemonic.sentence);
      ref.watch(mnemonicPhraseProvider.notifier).state = mnemonic.sentence;

      // print(currentPlatform);
    });
    // print(ref.watch(mnemonicPhraseProvider));
    // print);

    // print(service.readAllSecureData());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Padding(
                //   padding: EdgeInsets.all(20),

                // ),
                Lottie.asset(
                  "assets/animations/recover.json",
                  height: 200,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Recovery Phrase",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                for (var i = 0;
                    i < ref.watch(mnemonicPhraseProvider).split(" ").length / 2;
                    i++)
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 155,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: mainColor,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            "${i * 2 + 1}. ${ref.watch(mnemonicPhraseProvider).split(" ")[i * 2]}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        margin: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 155,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: mainColor,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            "${i * 2 + 2}. ${ref.watch(mnemonicPhraseProvider).split(" ")[i * 2 + 1]}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),

                //   const SizedBox(
                //     width: 10,
                //     height: 10,
                //   ),
                // ],
                // ),

                // Container(
                //   width: 150,
                //   padding: EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15),
                //     border: Border.all(
                //       color: mainColor,
                //       width: 2,
                //     ),
                //   ),
                //   child: Text(
                //     "${i + 2}. ${ref.watch(mnemonicPhraseProvider).split(" ")[i + 1]}",
                //     style: TextStyle(
                //       fontSize: 25,
                //       fontWeight: FontWeight.bold,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // )

                // const _TextField(label: 'Email address', icon: Icons.email),
                SizedBox(height: 16),

                // const SizedBox(height: 5),
                passwordNotFound == true
                    ? Container(
                        child: Text(
                          "Invalid password",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      )
                    : Container(),

                const SizedBox(height: 20),
                Container(
                  height: 60,
                  width: 400,
                  child: ElevatedButton.icon(
                      icon: Icon(Icons.done),
                      label: Text(
                        "Complete",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        secureDataList.then((value) {
                          if (value!.isNotEmpty) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()));
                          }
                        });
                      }),
                ),
                const SizedBox(height: 30),
                Text(
                  "This is your Secret Recovery Phrase. Write it down on a paper and store it in a secure place to recover your account.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: Text(
                    "Reset Wallet",
                    style: TextStyle(
                      fontSize: 16,
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
