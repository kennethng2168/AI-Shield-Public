import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';

import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import '../../../constant.dart';
import '../../../services/secure_storage_service.dart';
import 'package:encrypt/encrypt.dart' as encryptLib;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;

import 'recovery.dart';

class SignUpForm extends ConsumerStatefulWidget {
  SignUpForm({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
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

  bool? passwordNotMatch;
  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;
    LocalStorageService service = LocalStorageService(currentPlatform);

    // print(service.readAllSecureData());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(80),
                ),
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                // const _TextField(label: 'Email address', icon: Icons.email),
                const SizedBox(height: 16),
                _TextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  hidden: true,
                ),
                _TextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  icon: Icons.lock,
                  hidden: true,
                ),
                const SizedBox(height: 5),
                passwordNotMatch == true
                    ? Container(
                        child: Text(
                          "Password Not Match",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w500),
                        ),
                        alignment: Alignment.topLeft,
                      )
                    : Container(),
                const SizedBox(height: 60),

                Container(
                  height: 60,
                  width: 400,
                  child: ElevatedButton.icon(
                      icon: Icon(Icons.wallet),
                      label: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        //Check if password and confirm password input match
                        if (_passwordController.text ==
                            _confirmPasswordController.text) {
                          //Generate a key randomly for encrypting the password with 32 bytes (256 bits)
                          final key = encryptLib.Key.fromSecureRandom(32);
                          //Convert the key from bytes to hex
                          var keyHex = bytesToHex(key.bytes);
                          //Encrypt the password with the key and set the mode to Counter (CTR) mode
                          final encrypter = encryptLib.Encrypter(encryptLib.AES(
                            key,
                            mode: encryptLib.AESMode.ctr,
                          )); //CTR
                          //Generate a random IV with 16 bytes (128 bits)
                          final iv = encryptLib.IV.fromUtf8("password_mranti");

                          // Encrypted using AES with iv: IV.fromLength(16) public key and encrypter private key
                          final encrypted = encrypter
                              .encrypt(_confirmPasswordController.text, iv: iv);
                          //Convert the encrypted password from bytes to hex
                          var passwordHex = bytesToHex(encrypted.bytes);

                          //Keypair for and poly1305 for encrypt-then-mac approach
                          var keyPair = randomBytes(32);
                          var keyMAC = poly1305auth(encrypted.bytes, keyPair);

                          // Constructs Mnemonic from random secure 256bits entropy with optional passphrase
                          var mnemonic = Mnemonic.generate(
                            Language.english,
                            passphrase: "SomethingR0bùst",
                            entropyLength: 128,
                          );
                          final modifiedMnemonic = (mnemonic.words
                              .toString()
                              .replaceAll("[", "")
                              .replaceAll("]", "")
                              .replaceAll(",", "")
                              .trim());

                          final seed = bip39.mnemonicToSeed(modifiedMnemonic);
                          final isValidMnemonic = bip39
                              .validateMnemonic(modifiedMnemonic.toString());
                          print(modifiedMnemonic);
                          print(isValidMnemonic);
                          if (!isValidMnemonic) {
                            throw 'Invalid mnemonic';
                          }
                          String hdPath = "m/44'/60'/0'/0";
                          final root = bip32.BIP32.fromSeed(seed);

                          const first = 0;
                          final firstChild = root.derivePath("$hdPath/$first");
                          final privateKey =
                              HEX.encode(firstChild.privateKey as List<int>);
                          final _credentials =
                              EthPrivateKey.fromHex(privateKey);
                          print(_credentials.address);

                          //Store the data into a secure local storage with the following parameters
                          var storage = LocalStorage(
                            categories: "password",
                            value: keccak512sum(passwordHex),
                            mac: keccak512sum(keyMAC.toString()),
                            mnemonicSeed: modifiedMnemonic,
                            mnemonicEntropy: hex.encode(mnemonic.entropy),
                            keyHex: keyHex,
                            keyPair: bytesToHex(keyPair),
                            rewards: '0.0, 0.0, 0.0, 0.0',
                            rewardCompleted: 0,
                            albumCompleted: 0,
                            dataLength: 0,
                            chance: 0,
                          );
                          //Write the data into the secure local storage
                          LocalStorageService service =
                              LocalStorageService(currentPlatform);
                          service.writeData(storage);
                          //Navigate to the recovery page
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecoveryPage(),
                              ));
                        } else {
                          //If password and confirm password input does not match, set the passwordNotMatch to true
                          setState(() {
                            passwordNotMatch = true;
                            _confirmPasswordController.clear();
                            _passwordController.clear();
                          });
                        }

                        // print(service.readAllSecureData());
                      }),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  child: Text(
                    "Already have an account? Sign in.",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
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

class _TextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool hidden;
  final TextEditingController controller;

  const _TextField({
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
