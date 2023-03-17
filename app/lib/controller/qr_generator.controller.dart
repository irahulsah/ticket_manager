import 'package:hooks_riverpod/hooks_riverpod.dart';

StateProvider excelFileProvider = StateProvider((ref) => null);
StateProvider extractedDataFromFile = StateProvider((ref) => null);
StateProvider qrCodesProvider = StateProvider((ref) => []);
StateProvider qrCodesKeysProvider = StateProvider((ref) => []);
StateProvider exampleImages = StateProvider((ref) => []);
StateProvider loadingProvider = StateProvider((ref) => false);
StateProvider randomQrUuidProvider = StateProvider((ref) => []);

//
StateProvider scannedQrList = StateProvider((ref) => []);
StateProvider scannedCountProvider = StateProvider((ref) => 0);
StateProvider scannedPercentageProvider = StateProvider((ref) => 0);
StateProvider scannedQrListLoading = StateProvider((ref) => true);

StateProvider qrCodeScannedData = StateProvider((ref) => null);
StateProvider eventDataProvider = StateProvider((ref) => []);
StateProvider isLoadingProvider = StateProvider((ref) => false);

StateProvider<String> eventValueDropdown = StateProvider<String>((ref) => "");

AutoDisposeStateProvider fillFormManuallyProvider =
    AutoDisposeStateProvider((ref) => false);
AutoDisposeStateProvider fillFormManuallyFieldsProvider =
    AutoDisposeStateProvider((ref) => []);
