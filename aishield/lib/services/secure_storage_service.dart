import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encryptLib;

class LocalStorage {
  String? categories;
  String? value;
  String? mnemonicSeed;
  // String iv;
  String? mnemonicEntropy;
  String? keyHex;
  String? mac;
  String? rewards;
  int? rewardCompleted;
  int? albumCompleted;
  int? dataLength;
  int? chance;

  String keyPair;
  LocalStorage(
      {this.categories = "password",
      this.value = "Default",
      this.mac = "Default",
      this.mnemonicSeed = "Default",
      this.mnemonicEntropy = "",
      this.keyHex = "",
      this.keyPair = "",
      this.rewards = "",
      this.rewardCompleted,
      this.albumCompleted,
      this.dataLength,
      this.chance});
}

class LocalStorageService {
  var platform;
  LocalStorageService(this.platform);
  FlutterSecureStorage _storage = new FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  IOSOptions _getIOSOptions() =>
      IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  Future<String?> writeData(LocalStorage storageItem) async {
    if (platform == TargetPlatform.iOS) {
      print("True");
      await _storage.write(
        iOptions: _getIOSOptions(),
        key: storageItem.categories.toString(),
        value: storageItem.value,
      );
      await _storage.write(
        iOptions: _getIOSOptions(),
        key: "recovery",
        value: storageItem.mnemonicEntropy.toString(),
      );
      await _storage.write(
        iOptions: _getIOSOptions(),
        key: "keyHex",
        value: storageItem.keyHex,
      );
      await _storage.write(
        iOptions: _getIOSOptions(),
        key: "mac",
        value: storageItem.mac,
      );
      await _storage.write(
        iOptions: _getIOSOptions(),
        key: "keyPair",
        value: storageItem.keyPair,
      );
      await _storage.write(
        iOptions: _getIOSOptions(),
        key: "seed",
        value: storageItem.mnemonicSeed.toString(),
      );
      await _storage.write(
        iOptions: _getIOSOptions(),
        key: "rewards",
        value: storageItem.rewards.toString(),
      );
      await _storage.write(
        iOptions: _getIOSOptions(),
        key: "rewardCompleted",
        value: storageItem.rewardCompleted.toString(),
      );
      await _storage.write(
        iOptions: _getIOSOptions(),
        key: "albumCompleted",
        value: storageItem.albumCompleted.toString(),
      );
      await _storage.write(
        iOptions: _getIOSOptions(),
        key: "dataLength",
        value: storageItem.dataLength.toString(),
      );
      await _storage.write(
        iOptions: _getIOSOptions(),
        key: "chance",
        value: storageItem.chance.toString(),
      );
      return "IOS Write Data";
    } else if (platform == TargetPlatform.android) {
      await _storage.write(
        aOptions: _getAndroidOptions(),
        key: storageItem.categories.toString(),
        value: storageItem.value,
      );
      await _storage.write(
        aOptions: _getAndroidOptions(),
        key: "recovery",
        value: storageItem.mnemonicEntropy.toString(),
      );
      await _storage.write(
        aOptions: _getAndroidOptions(),
        key: "keyHex",
        value: storageItem.keyHex,
      );
      await _storage.write(
        aOptions: _getAndroidOptions(),
        key: "mac",
        value: storageItem.mac,
      );

      await _storage.write(
        aOptions: _getAndroidOptions(),
        key: "keyPair",
        value: storageItem.keyPair,
      );
      await _storage.write(
        aOptions: _getAndroidOptions(),
        key: "seed",
        value: storageItem.mnemonicSeed.toString(),
      );
      await _storage.write(
        aOptions: _getAndroidOptions(),
        key: "rewards",
        value: storageItem.rewards.toString(),
      );
      await _storage.write(
        aOptions: _getAndroidOptions(),
        key: "rewardCompleted",
        value: storageItem.rewardCompleted.toString(),
      );
      await _storage.write(
        aOptions: _getAndroidOptions(),
        key: "albumCompleted",
        value: storageItem.albumCompleted.toString(),
      );
      await _storage.write(
        aOptions: _getAndroidOptions(),
        key: "dataLength",
        value: storageItem.dataLength.toString(),
      );
      await _storage.write(
        aOptions: _getAndroidOptions(),
        key: "chance",
        value: storageItem.chance.toString(),
      );
      return "Android Write Data";
    } else {
      print("Target Platform Not found");
      return "Platform Not Found";
    }
  }

  Future<String?> readData(LocalStorage storageItem) async {
    var data;
    if (platform == TargetPlatform.iOS) {
      data = await _storage.read(
          key: storageItem.categories.toString(), iOptions: _getIOSOptions());
    } else if (platform == TargetPlatform.android) {
      data = await _storage.read(
          key: storageItem.categories.toString(),
          aOptions: _getAndroidOptions());
    } else {
      data = "None";
      print("Target Platform Not found");
    }
    return data;
  }

  Future<String?> deleteData(LocalStorage storageItem) async {
    if (platform == TargetPlatform.iOS) {
      await _storage.delete(
          key: storageItem.categories.toString(), iOptions: _getIOSOptions());
    } else if (platform == TargetPlatform.android) {
      await _storage.delete(
          key: storageItem.categories.toString(),
          aOptions: _getAndroidOptions());
    } else {
      print("Target Platform Not found");
    }
  }

  Future<bool?> containsKeyInSecureData(String key) async {
    if (TargetPlatform.iOS == true) {
      var containsKey =
          await _storage.containsKey(key: key, iOptions: _getIOSOptions());
      return containsKey;
    } else if (TargetPlatform.android == true) {
      var containsKey =
          await _storage.containsKey(key: key, aOptions: _getAndroidOptions());
      return containsKey;
    } else {
      print("Target Platform Not found");
    }
  }

  Future<void> deleteAllData() async {
    _storage.deleteAll();
  }

  Future<List?> readAllSecureData() async {
    if (platform == TargetPlatform.iOS) {
      Map<String, String> allValue =
          await _storage.readAll(iOptions: _getIOSOptions());

      // print(allValue);
      var listStorage = [];
      listStorage.add(allValue["password"]);
      listStorage.add(allValue["recovery"]);
      listStorage.add(allValue["keyHex"]);
      listStorage.add(allValue["mac"]);
      listStorage.add(allValue["keyPair"]);
      listStorage.add(allValue["seed"]);
      listStorage.add(allValue["rewards"]);
      listStorage.add(allValue["rewardCompleted"]);
      listStorage.add(allValue["albumCompleted"]);
      listStorage.add(allValue["dataLength"]);
      listStorage.add(allValue["chance"]);

      // print(listStorage);
      return listStorage;
      // return list;
    } else if (platform == TargetPlatform.android) {
      Map<String, String> allValue =
          await _storage.readAll(aOptions: _getAndroidOptions());
      var listStorage = [];
      listStorage.add(allValue["password"]);
      listStorage.add(allValue["recovery"]);
      listStorage.add(allValue["keyHex"]);
      listStorage.add(allValue["mac"]);
      listStorage.add(allValue["keyPair"]);
      listStorage.add(allValue["seed"]);
      listStorage.add(allValue["rewards"]);
      listStorage.add(allValue["rewardCompleted"]);
      listStorage.add(allValue["albumCompleted"]);
      listStorage.add(allValue["dataLength"]);
      listStorage.add(allValue["chance"]);

      // print(listStorage);
      return listStorage;
      // return list;
    } else {
      print("Target Platform Not found");
    }
  }
}
