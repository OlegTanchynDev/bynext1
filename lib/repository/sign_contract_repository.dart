import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../constants.dart';

class SignContractRepository {

  Future<String> performUploadFileWithImage(http.Client client, String token, Uint8List imageData) async {
    var request = http.MultipartRequest('POST', Uri.parse('$servicesUrl/delivery/v2/uploads/uploadImage/'));
    request.headers.addAll({
      'Authorization' : "Token $token",
      'Accept-Encoding': 'gzip',
    });
    request.files.add(http.MultipartFile.fromBytes('image.jpg', imageData, filename: 'image.jpg'));
    request.fields['type'] = 'contract_sign';
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var data = String.fromCharCodes(responseData);//[\"contract_sign/68f3f2ecba4f11eab47d0e597bedbf65.jpg\"]
    List parsed = json.decode(data);
    if (response.statusCode == 200 && parsed.length==1) {
      return Future.value(parsed[0]);
    } else  {
      return Future.value(null);
    }
  }

  Future<dynamic> performWithContractID(http.Client client, String token, int contractId, String imageUrl, String deviceID) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/contract/sign/?contract_id=$contractId&device_id=$deviceID&signature_url=$imageUrl',
      headers: {
        'content-type': 'application/json',
        'Authorization' : "Token $token",
        'Accept-Encoding': 'gzip',
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Future.value(parsed);
    } else  {
      return Future.value(null);
//      throw RestError.fromMap(parsed);
    }
  }

}
