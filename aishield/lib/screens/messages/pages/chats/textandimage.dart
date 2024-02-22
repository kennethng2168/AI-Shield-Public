import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../constant.dart';

/// -----------------------------------------------------
class SectionTextAndImageInput extends StatefulWidget {
  const SectionTextAndImageInput({super.key});

  @override
  State<SectionTextAndImageInput> createState() =>
      _SectionTextAndImageInputState();
}

class _SectionTextAndImageInputState extends State<SectionTextAndImageInput> {
  final ImagePicker picker = ImagePicker();
  final controller = TextEditingController();

  String? searchedText, result, _currentLanguageID, status, error, words;
  bool _loading = false;
  Uint8List? selectedImage;
  bool get loading => _loading;
  set loading(bool set) => setState(() => _loading = set);
  final gemini = Gemini.instance;
  bool _speech = false;
  bool _device = true;
  double level = 0.0;
  double minimumSound = 50000;
  double maximumSound = -50000;
  final SpeechToText speech = SpeechToText();
  bool _logEvents = false;
  List<LocaleName> _languageName = [];
  Color micColor = mainColor;

  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await speech.initialize(
        // onError: errorListener,
        // onStatus: statusListener,
        debugLogging: _logEvents,
      );
      if (hasSpeech) {
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.
        _languageName = await speech.locales();

        var systemLocale = await speech.systemLocale();
        _currentLanguageID = systemLocale?.localeId ?? 'English';
      }
      if (!mounted) return;

      setState(() {
        _speech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        error = 'Speech recognition failed: ${e.toString()}';
        _speech = false;
      });
    }
  }

  // To recognize new speech from users
  void startListening() {
    _logEvent('start listening');
    words = '';
    error = '';
    speech.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 4),
      partialResults: true,
      localeId: _currentLanguageID,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
      onDevice: _device,
    );
    setState(() {});
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    controller.text = words!;

    setState(() {
      micColor = mainColor;
      words = '${result.recognizedWords}';
    });
  }

  void soundLevelListener(double level) {
    minimumSound = min(minimumSound, level);
    maximumSound = max(maximumSound, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError current_error) {
    _logEvent(
        'Received error status: $current_error, listening: ${speech.isListening}');
    setState(() {
      error = '${current_error.errorMsg} - ${current_error.permanent}';
      micColor = mainColor;
    });
  }

  void statusListener(String current_status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      status = current_status;
    });
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLanguageID = selectedVal;
    });
    debugPrint(selectedVal);
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      debugPrint('$eventTime $eventDescription');
    }
  }

  void _switchLogging(bool? val) {
    setState(() {
      _logEvents = val ?? false;
    });
  }

  void _switchOnDevice(bool? val) {
    setState(() {
      _device = val ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (searchedText != null)
          MaterialButton(
            color: mainColor,
            onPressed: () {
              setState(() {
                searchedText = null;
                result = null;
              });
            },
            child: Text(
              'Search: $searchedText',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: loading
                      ? Container(
                          child: Lottie.asset('assets/animations/ai.json'),
                          height: 500,
                        )
                      : result != null
                          ? Markdown(
                              data: result!,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                            )
                          : Center(
                              child: Text(
                                "Search with this image...",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        selectedImage != null
            ? Container(
                height: 250,
                child:
                    // Expanded(
                    //   flex: 1,
                    ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.memory(
                    selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(),
        Card(
          margin: const EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  hintText: 'Type Here...',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) => () {
                  if (controller.text.isNotEmpty && selectedImage != null) {
                    searchedText = controller.text;
                    controller.clear();
                    loading = true;
                    gemini.textAndImage(
                        text: searchedText!,
                        images: [selectedImage!]).then((value) {
                      result = value?.content?.parts?.last.text;
                      loading = false;
                    });
                  }
                },
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              )),
              Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: IconButton(
                  icon: Icon(Icons.mic),
                  color: micColor,
                  onPressed: () async {
                    setState(() {
                      micColor = Colors.green;
                    });

                    initSpeechState();
                    startListening();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: IconButton(
                    color: mainColor,
                    onPressed: () async {
                      // Capture a photo.
                      final photo = await ImagePicker().pickImage(
                        imageQuality: 70,
                        maxWidth: 1440,
                        source: ImageSource.gallery,
                      );
                      // final XFile? photo =
                      //     await picker.pickImage(source: ImageSource.camera);

                      if (photo != null) {
                        photo.readAsBytes().then((value) => setState(() {
                              selectedImage = value;
                            }));
                      }
                    },
                    icon: const Icon(Icons.file_copy)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty && selectedImage != null) {
                        searchedText = controller.text;
                        controller.clear();
                        loading = true;
                        gemini.textAndImage(
                            text: searchedText!,
                            images: [selectedImage!]).then((value) {
                          result = value?.content?.parts?.last.text;
                          print(result);
                          loading = false;
                        });
                      }
                    },
                    icon: Icon(Icons.send, color: mainColor)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
