import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';

import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashlib/hashlib.dart';
import 'package:lottie/lottie.dart';

import 'package:web3dart/crypto.dart';
import '../../../constant.dart';
import '../../../providers.dart';
import '../../../services/secure_storage_service.dart';
import 'package:encrypt/encrypt.dart' as encryptLib;

import 'sign_in_page.dart';

class RecoverPasswordPage extends ConsumerStatefulWidget {
  RecoverPasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RecoverPasswordPage> createState() =>
      _RecoveryPasswordPageFormState();
}

class _RecoveryPasswordPageFormState
    extends ConsumerState<RecoverPasswordPage> {
  @override
  void initState() {
    super.initState();

    // var _items = await _localStorageService.readAllSecureData();
    // print(_items);
  }

  bool phraseNotFound = false;
  bool passwordNotFound = false;
  bool errorSubmit = false;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _recoverController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();
    var currentPlatform = Theme.of(context).platform;

    LocalStorageService service = LocalStorageService(currentPlatform);
    var secureDataList = service.readAllSecureData();

    // print(ref.watch(mnemonicPhraseProvider));
    // print);

    // print(service.readAllSecureData());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recover Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
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
                  height: 230,
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
                  height: 20,
                ),
                // Flex(
                //   direction: Axis.vertical,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [

                // const SizedBox(
                //   width: 10,
                //   height: 10,
                // ),
                // Flex(direction: Axis.vertical, children: [

                // Column(
                //   children: <Widget>[
                _TextField(
                  controller: _recoverController,
                  label: 'Secret Recovery Phrase',
                  icon: Icons.lock,
                  hidden: false,
                ),
                _TextField(
                  controller: _passwordController,
                  label: 'New password',
                  icon: Icons.password,
                  hidden: true,
                ),
                _TextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm password',
                  icon: Icons.password,
                  hidden: true,
                ),
                // const _TextField(label: 'Email address', icon: Icons.email),
                SizedBox(height: 5),

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
                    : errorSubmit == true
                        ? Container(
                            child: Text(
                              "Please fill in required information",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                          )
                        : phraseNotFound == true
                            ? Container(
                                child: Text(
                                  "Please fill in required information",
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
                      icon: Icon(Icons.lock, color: Colors.white),
                      label: Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Check whether the textfield is empty or not
                        if (_recoverController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty &&
                            _confirmPasswordController.text.isNotEmpty) {
                          secureDataList.then((value) {
                            // If the local storage is registered/not empty
                            if (value!.isNotEmpty) {
                              // Get the entropy from the local storage
                              List<int> bytesEntropy = hex.decode(value[1]);
                              // Generate mnemonic from entropy
                              var mnemonic =
                                  Mnemonic(bytesEntropy, Language.english);

                              ref.watch(mnemonicPhraseProvider.notifier).state =
                                  mnemonic.sentence;
                              // Check whether the mnemonic is matched or not
                              if (_recoverController.text ==
                                  mnemonic.sentence) {
                                //Generate AES key from password and iv 32bytes (256bits)
                                final key = encryptLib.Key.fromSecureRandom(32);
                                // Convert the key from bytes to hex
                                var keyHex = bytesToHex(key.bytes);
                                // Create an encrypter with the key and counter mode (CTR)
                                final encrypter =
                                    encryptLib.Encrypter(encryptLib.AES(
                                  key,
                                  mode: encryptLib.AESMode.ctr,
                                )); //CTR
                                // Create an IV
                                final iv = encryptLib.IV.fromUtf8("password" +
                                    _confirmPasswordController.text);

                                // Encrypted using AES with iv: IV.fromLength(16) public key and encrypter private key
                                final encrypted = encrypter.encrypt(
                                    _confirmPasswordController.text,
                                    iv: iv);
                                // Generate a random key for the poly1305auth with 32 bytes (256 bits)
                                var keyPair = randomBytes(32);
                                var keyMAC =
                                    poly1305auth(encrypted.bytes, keyPair);

                                // Convert the password from bytes to hex
                                var passwordHex = bytesToHex(encrypted.bytes);
                                // Create storage object to store all data such as password, mnemonic, key, iv
                                var storage = LocalStorage(
                                    categories: "password",
                                    value: keccak512sum(passwordHex),
                                    mac: keccak512sum(keyMAC.toString()),
                                    mnemonicSeed: value[1],
                                    keyHex: keyHex,
                                    keyPair: bytesToHex(keyPair));
                                // Write the encrypted password to local storage
                                service.writeData(storage);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInPage()));
                              } else {
                                setState(() {
                                  phraseNotFound = true;
                                  errorSubmit = false;
                                  passwordNotFound = false;
                                });
                              }
                            }
                          });
                        } else {
                          setState(() {
                            errorSubmit = true;
                          });
                        }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => SignInPage(),
                        //     ));
                      }),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool hidden;
  final TextEditingController controller;

  _TextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.hidden = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: controller,
              cursorColor: mainColor,
              obscureText: hidden,
              autocorrect: !hidden,
              enableSuggestions: !hidden,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
                suffixIcon: Icon(
                  icon,
                  color: Colors.grey.shade400,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: mainColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
