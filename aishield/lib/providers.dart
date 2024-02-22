import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/storage_service.dart';
import '../../services/firestore_service.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final latitudeProvider = StateProvider<String>((ref) => "");
final longitudeProvider = StateProvider<String>((ref) => "");
final mnemonicPhraseProvider = StateProvider<String>((ref) => "");
final contractAddressProvider = StateProvider<String>((ref) => "");
final passwordStatesProvider = StateProvider<bool>((ref) => false);
final confirmPasswordStatesProvider = StateProvider<bool>((ref) => false);
final mnemonicPhraseStatesProvider = StateProvider<bool>((ref) => false);

final databaseProvider = Provider<FirestoreService?>((ref) {
  return FirestoreService();
});

final storageProvider = Provider<StorageService?>((ref) {
  // final auth = ref.watch(authStateChangesProvider);
  // String? uid = auth.asData?.value?.uid;
  // if (uid != null) {
  // return StorageService(uid: uid);
  return StorageService();
  // }
  // return null;
});
