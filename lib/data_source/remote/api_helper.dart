import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as https;
import 'package:wscube_wallpaper_app/data_source/remote/api_exception.dart';
import 'package:wscube_wallpaper_app/data_source/remote/urls.dart';

class ApiHelper {
  Future<dynamic> getApi(String url, {Map<String, String>? headers}) async {
    var uri = Uri.parse(url);

    try {
      var response = await https.get(uri,
          headers: headers ?? {"Authorization": Urls.API_KEY});
      return returnDataResponse(response);
    } on SocketException {
      /// Internet Exception
      throw FetchDataException(body: "Internet Error");
    }
  }

  dynamic returnDataResponse(https.Response response) {
    switch (response.statusCode) {
      case 200:
        var actualRes = response.body;
        var mData = jsonDecode(actualRes);
        return mData;

      case 400:
        throw BadRequestException(body: response.body.toString());

      case 401:
      case 403:
        throw UnauthorisedException(body: response.body.toString());

      case 500:
      default:
        throw FetchDataException(
            body:
                'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
