import 'dart:typed_data';
import 'dart:convert';

import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:web3dart/crypto.dart';
import '../../../constant.dart';
import 'log_in.dart';
import 'signup.dart';
import 'package:encrypt/encrypt.dart' as encryptLib;
import 'package:convert/convert.dart';

import '../../../services/secure_storage_service.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;

    LocalStorageService service = LocalStorageService(currentPlatform);
    var secureDataList = service.readAllSecureData();

    secureDataList.then((value) {
      if (value!.isNotEmpty) {
        print("TRUE");
      } else {}
    });
    return Scaffold(
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Padding(padding: EdgeInsets.all(50.0)),
            Center(
              child: Lottie.asset("assets/animations/crypto_wallet.json"),
            ),
            const SizedBox(height: 10),
            Text(
              "Private and Secure",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Your data never leave your device.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            Container(
              height: 60,
              width: 350,
              child: ElevatedButton.icon(
                icon: Icon(Icons.wallet),
                label: Text(
                  "Create a new account",
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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpForm(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LogInPage())),
              child: Text(
                "I already have an account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
