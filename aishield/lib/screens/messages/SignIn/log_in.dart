import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashlib/hashlib.dart';
import 'package:lottie/lottie.dart';
import 'package:web3dart/crypto.dart';
import '../../../constant.dart';
import '../../../providers.dart';
import '../../../services/secure_storage_service.dart';
import 'package:encrypt/encrypt.dart' as encryptLib;

import '../../main/main_screen.dart';
import 'recover_password.dart';
import 'signup.dart';

class LogInPage extends ConsumerStatefulWidget {
  LogInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LogInPage> createState() => _LogInFormState();
}

class _LogInFormState extends ConsumerState<LogInPage> {
  @override
  // final LocalStorageService _localStorageService = LocalStorageService();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // var _items = await _localStorageService.readAllSecureData();
    // print(_items);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool passwordNotFound = false;
  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;

    LocalStorageService service = LocalStorageService(currentPlatform);
    var secureDataList = service.readAllSecureData();
    bool isPasswordText = false;
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
                  "assets/animations/welcome.json",
                  height: 280,
                ),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          onChanged: (_) {
                            if (_passwordController.text.isNotEmpty) {
                              ref.watch(passwordStatesProvider.notifier).state =
                                  true;
                            } else {
                              ref.watch(passwordStatesProvider.notifier).state =
                                  false;
                            }
                          },
                          controller: _passwordController,
                          cursorColor: mainColor,
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                            errorText: passwordNotFound == true
                                ? "Invalid Password"
                                : null,
                            errorStyle: TextStyle(
                              fontSize: 15,
                            ),
                            suffixIcon: Icon(
                              Icons.lock,
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
                ),

                const SizedBox(height: 10),
                Container(
                  height: 60,
                  width: 400,
                  child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.no_encryption,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Unlock",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            ref.watch(passwordStatesProvider) == true
                                ? mainColor
                                : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Show the secure data list for local storage
                        secureDataList.then((value) {
                          if (value!.isNotEmpty) {
                            // Get the Encrypted Key from the secure local storage
                            var encryptedKey =
                                encryptLib.Key(hexToBytes(value?[2]));
                            // Get the IV from the password
                            final iv =
                                encryptLib.IV.fromUtf8("password_mranti");
                            // Generate the encrypted key with AES Counter Mode (AES-CTR)
                            var encrypter = encryptLib.Encrypter(encryptLib.AES(
                                encryptedKey,
                                mode: encryptLib.AESMode.ctr));
                            // Encrypt the password with the encrypter key and IV
                            final encrypted = encrypter
                                .encrypt(_passwordController.text, iv: iv);

                            // Convert the encrypted password to hex
                            var passwordHex = bytesToHex(encrypted.bytes);
                            // Check whether the password is matched after keccak512 hashing for passwordHex and IV
                            // If matched, decrypt the password and navigate to the main screen
                            // Keyhased poly1305 authentication
                            var keyMAC = poly1305auth(encrypted.bytes,
                                hexToBytes(value[5])); //With the keypair stored
                            // keyhased poly1305 double hashing with keccak512

                            if (keccak512sum(keyMAC.toString()) == value[3]) {
                              // Check whether the password is matched after keccak512 hashing for passwordHex and IV
                              if (keccak512sum(passwordHex) == value[0]) {
                                final decrypted = encrypter.decrypt(
                                  encryptLib.Encrypted(hexToBytes(passwordHex)),
                                  iv: iv,
                                );
                                // Set the password to the provider
                                setState(() {
                                  passwordNotFound = false;
                                });
                                ref
                                    .watch(passwordStatesProvider.notifier)
                                    .state = false;
                                Navigator.pushReplacementNamed(
                                    context, '/mainScreen');
                              } else {
                                setState(() {
                                  passwordNotFound = true;
                                  _passwordController.clear();
                                });
                              }
                            } else {
                              setState(() {
                                passwordNotFound = true;
                                _passwordController.clear();
                              });
                            }
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpForm()));
                          }
                        });
                      }),
                ),
                const SizedBox(height: 30),
                Text(
                  "Wallet won't unlock? You can ERASE your current wallet and setup a new wallet",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),
                GestureDetector(
                  child: Text(
                    "Recover Password",
                    style: TextStyle(
                      fontSize: 18,
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecoverPasswordPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
