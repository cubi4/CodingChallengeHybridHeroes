import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

Future<String> showQrCodeScanner(BuildContext context) async {
  var result;
  try {
    result = await BarcodeScanner.scan();
  } on PlatformException catch (e) {
    var result = ScanResult(
      type: ResultType.Error,
      format: BarcodeFormat.unknown,
    );
    if (e.code == BarcodeScanner.cameraAccessDenied) {
      print('The user did not grant the camera permission!');
      return result.rawContent =
          'The user did not grant the camera permission!';
    } else {
      print('Unknown error: $e');
      return result.rawContent = null;
    }
  }
  return result.rawContent;
}
