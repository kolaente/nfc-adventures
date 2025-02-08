import 'package:nfc_manager/nfc_manager.dart';

class NfcService {
  static Future<String?> readNfcTag() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) return null;

    String? tagId;
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      print(tag);
      Ndef? ndef = Ndef.from(tag);
      print(ndef);
      //var nfcA = NfcA.from(tag);
      //if (nfcA != null) {
      //  tagId = nfcA.identifier.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':');
      //}
      //await NfcManager.instance.stopSession();
    });

    return tagId;
  }
}
