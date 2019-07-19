import 'dart:convert';

import 'package:http_client_helper/http_client_helper.dart';
import 'package:travel/model/search_model.dart';

class SearchDao {
  static Future<SearchModel> fetch(String url, String keyword) async {
    var cancellationToken = CancellationToken();
    var response = await HttpClientHelper.get(url,
        cancelToken: cancellationToken,
        timeRetry: Duration(milliseconds: 100),
        retries: 3,
        timeLimit: Duration(seconds: 5)
    );
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      SearchModel model = SearchModel.fromJson(result);
      model.keyword = keyword;
      return model;
    }else {
      throw Exception('faild');
    }
  }
}