import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

Future<String> showQrCodeScanner(BuildContext context) async {
  try {
    String result = await BarcodeScanner.scan();
    return result;
  } on PlatformException catch (e) {
    print(e);
    if (e.code == 'PERMISSION_NOT_GRANTED') {
      print('barcode scaner no permission');
    }
    return null;
  } catch (e) {
    print(e);
    return null;
  }
}
