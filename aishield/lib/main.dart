import 'package:convert/convert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_injected_web3/flutter_injected_web3.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashlib/hashlib.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authwidget.dart';
import 'constant.dart';
import 'firebase_options.dart';
import 'screens/Report/report.dart';
import 'screens/main/main_screen.dart';
import 'screens/messages/SignIn/sign_in_page.dart';
import 'services/local_auth.dart';
import 'services/secure_storage_service.dart';
import 'package:encrypt/encrypt.dart' as encryptLib;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(apiKey: 'AIzaSyA95BAYSi0Y12io6zfO4CwmwWtCH3MeSOs');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(ProviderScope(child: DisasterApp())));
}

class DisasterApp extends StatefulWidget {
  DisasterApp({Key? key}) : super(key: key);
  @override
  State<DisasterApp> createState() => _DisasterAppState();
}

class _DisasterAppState extends State<DisasterApp> {
  bool? _jailbroken;
  bool? _developerMode;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    // authenticate();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool jailbroken;
    bool developerMode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _jailbroken = jailbroken;
      _developerMode = developerMode;
    });
  }

  var isAuthenticate;
  // Check whether biometric is enabled or not
  Future<bool?> authenticate() async {
    var currentPlatform = Theme.of(context).platform;
    LocalStorageService service = LocalStorageService(currentPlatform);
    var secureDataList = service.readAllSecureData();
    var flag;
    // Check whether existing data is present or not
    secureDataList.then((value) async {
      if (value!.isNotEmpty) {
        print(true);
        flag = true;
        var authenticate = await LocalAuth.authenticate();
        setState(() {
          isAuthenticate = authenticate;
        });
      } else {
        print(value);
        flag = false;
      }
    });
    return isAuthenticate;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      title: 'Emergency Response App (RescueEye)',
      debugShowCheckedModeBanner: false,

      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(primary: mainColor),
      ),

      // Check whether biometric is enabled or not
      // home: isAuthenticate == true ? MainScreen() : SignInPage(),
      home: SignInPage(),
      routes: {
        '/reportPage': (context) => Report(),
        '/mainScreen': (context) => MainScreen(),
        '/signInPage': (context) => SignInPage(),
      },
    );
  }
}
