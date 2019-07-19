import 'package:flutter/material.dart';
import 'package:travel/dao/search_dao.dart';
import 'package:travel/model/search_model.dart';
import 'package:travel/util/navigator_util.dart';
import 'package:travel/widget/search_bar.dart';
import 'package:travel/widget/webview.dart';

const BASE_URL =
    'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';
const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];
class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;
  const SearchPage(
      {Key key,
      this.hideLeft,
      this.searchUrl = BASE_URL,
      this.keyword,
      this.hint})
      : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        _appBar(),
        MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Expanded(
            flex: 1,
            child: ListView.builder(
                itemCount: searchModel?.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return _item(index);
                }),
          ),
        )
      ],
    ));
  }

  void _onTextChange(String text) {
    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    keyword = text;
    String url = widget.searchUrl + text;
    SearchDao.fetch(url, keyword).then((SearchModel model) {
      setState(() {
        searchModel = model;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _appBar() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),
        )
      ],
    );
  }

  Widget _item(int index) {
    if (searchModel == null || searchModel.data == null) {
      return null;
    }
    SearchItem item = searchModel.data[index];
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            WebView(
              url: item.url,
              title: '详情',
            ));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(1),
              child: Image(
                height: 26,
                width: 26,
                image: AssetImage(_typeImage(item.type)),
                
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(item),
                ),
                Container(
                    width: 300,
                    margin: EdgeInsets.only(top: 5),
                    child: _subTitle(item))
              ],
            )
          ],
        ),
      ),
    );
  }

  String _typeImage(String type) {
    if (type == null) {
      return 'assets/images/type_travelgroup.png';
    }
    String path = 'travelgroup';
    for (final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'assets/images/type_${path}.png';
  }

  _title(SearchItem item) {
    if (item == null) {
      return null;
    }
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, keyword));
    spans.add(TextSpan(text: ' ' +(item.districtname??'')+' '+ (item.zonename??''),style: TextStyle(fontSize: 16, color: Colors.grey)));
    return RichText(text: TextSpan(children: spans));

  }
  _subTitle(SearchItem item) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: item.price??'',
            style: TextStyle(fontSize: 16, color: Colors.orange),
          ),
          TextSpan(
            text: ' ' + (item.star??''),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        ]
      ),
    );
  }

  Iterable<TextSpan> _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) {
      return spans;
    }
    List<String> arr = word.split(keyword);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    for (int i=0; i<arr.length; i++) {
      if ((i+1)%2==0) {
        spans.add(TextSpan(text: keyword, style: keywordStyle));
      }
      String val = arr[i];
      if(val!=null && val.length>0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }
}
