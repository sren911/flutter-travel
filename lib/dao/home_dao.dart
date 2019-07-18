import 'dart:async';
import 'dart:convert';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:travel/model/home_model.dart';
const HOME_URL = 'http://www.devio.org/io/flutter_app/json/home_page.json';
class HomeDao {

  static Future<HomeModel> fetch() async {
    var cancellationToken = CancellationToken();
    var response = await HttpClientHelper.get(HOME_URL,
        cancelToken: cancellationToken,
        timeRetry: Duration(milliseconds: 100),
        retries: 3,
        timeLimit: Duration(seconds: 5)
    );
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    }else {
      throw Exception('faild');
    }
  }
}