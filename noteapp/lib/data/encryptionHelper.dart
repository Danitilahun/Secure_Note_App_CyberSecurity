// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:pointycastle/export.dart';

// class EncryptionHelper {
//   static final _random = Random();

//   static Uint8List _generateKey() {
//     final keyLength = 32;
//     final key = Uint8List(keyLength);
//     for (var i = 0; i < keyLength; i++) {
//       key[i] = _random.nextInt(256);
//     }
//     return key;
//   }

//   static Uint8List encrypt(String data, Uint8List key) {
//     final params = PaddedBlockCipherParameters(KeyParameter(key), null);
//     final pbe = PaddedBlockCipher('AES/CBC/PKCS7')..init(true, params);
//     final utf8Data = utf8.encode(data);
//     final encryptedData = pbe.process(Uint8List.fromList(utf8Data));
//     return encryptedData;
//   }

//   static String decrypt(Uint8List encryptedData, Uint8List key) {
//     final params = PaddedBlockCipherParameters(KeyParameter(key), null);
//     final pbd = PaddedBlockCipher('AES/CBC/PKCS7')..init(false, params);
//     final decryptedData = pbd.process(Uint8List.fromList(encryptedData));
//     return utf8.decode(decryptedData);
//   }
// }
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:crypto/crypto.dart';

class EncryptionHelper {
  static final _random = Random();

  static List<int> generateKey(String password) {
    final keyLength = 32; // 256 bits
    final utf8Password = utf8.encode(password);
    final hashedPassword = sha256.convert(utf8Password);
    return hashedPassword.bytes.sublist(0, keyLength);
  }

  static Uint8List encrypt(String data, Uint8List key) {
    final cipher = CBCBlockCipher(AESFastEngine())
      ..init(true,
          ParametersWithIV<KeyParameter>(KeyParameter(key), Uint8List(16)));

    final utf8Data = utf8.encode(data);
    final paddedData = _padData(utf8Data);

    final encryptedData = cipher.process(paddedData);
    return encryptedData;
  }

  static String decrypt(Uint8List encryptedData, Uint8List key) {
    final cipher = CBCBlockCipher(AESFastEngine())
      ..init(false,
          ParametersWithIV<KeyParameter>(KeyParameter(key), Uint8List(16)));

    final decryptedData = cipher.process(encryptedData);
    final unpaddedData = _unpadData(decryptedData);

    return utf8.decode(unpaddedData);
  }

  static Uint8List _padData(List<int> data) {
    final blockSize = 16;
    final padLength = blockSize - (data.length % blockSize);
    final paddedData = Uint8List(data.length + padLength);
    paddedData.setRange(0, data.length, data);
    for (var i = data.length; i < paddedData.length; i++) {
      paddedData[i] = padLength;
    }
    return paddedData;
  }

  static Uint8List _unpadData(Uint8List data) {
    final padLength = data[data.length - 1];
    final unpaddedData = Uint8List(data.length - padLength);
    unpaddedData.setRange(0, unpaddedData.length, data);
    return unpaddedData;
  }
}
