import 'package:hooks_riverpod/hooks_riverpod.dart';

StateProvider excelFileProvider = StateProvider((ref) => null);
StateProvider extractedDataFromFile = StateProvider((ref) => null);
StateProvider qrCodesProvider = StateProvider((ref) => []);
StateProvider qrCodesKeysProvider = StateProvider((ref) => []);
StateProvider exampleImages = StateProvider((ref) => []);
StateProvider loadingProvider = StateProvider((ref) => false);
StateProvider randomQrUuidProvider = StateProvider((ref) => []);
