import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputButtonClick;
  final void Function(String text) onChanged;

  const SearchBar(
      {Key key,
      this.enabled = true,
      this.hideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputButtonClick,
      this.onChanged})
      : super(key: key);
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _genNormalSearch()
        : _genHomeSearch();
  }

  _genNormalSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                  padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
                  child: widget?.hideLeft ?? false
                      ? null
                      : Icon(
                          Icons.arrow_back_ios,
                          color: Colors.grey,
                          size: 26,
                        )),
              widget.leftButtonClick),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(
              Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    '搜索',
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  )),
              widget.leftButtonClick),
        ],
      ),
    );
  }

  _genHomeSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                  padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '上海',
                        style: TextStyle(color: _homeFontColor(), fontSize: 14),
                      ),
                      Icon(
                        Icons.expand_more,
                        color: _homeFontColor(),
                        size: 22,
                      )
                    ],
                  )),
              widget.leftButtonClick),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Icon(
                  Icons.comment,
                  color: _homeFontColor(),
                  size: 26,
                ),
              ),
              widget.leftButtonClick),
        ],
      ),
    );
  }

  _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) callback();
      },
      child: child,
    );
  }

  _inputBox() {
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(0xffededed);
    }
    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: inputBoxColor,
          borderRadius: BorderRadius.circular(
              widget.searchBarType == SearchBarType.normal ? 5 : 15)),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal
                ? Colors.grey
                : Colors.blue,
          ),
          Expanded(
              flex: 1,
              child: widget.searchBarType == SearchBarType.normal
                  ? TextField(
                      controller: _controller,
                      onChanged: _onChanged,
                      autofocus: true,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          border: InputBorder.none,
                          hintText: widget.hint ?? '',
                          hintStyle: TextStyle(fontSize: 15)),
                    )
                  : _wrapTap(
                      Container(
                        child: Text(
                          widget.defaultText,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                      widget.inputButtonClick)),
          !showClear
              ? _wrapTap(
                  Icon(
                    Icons.mic,
                    size: 22,
                    color: widget.searchBarType == SearchBarType.normal
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  widget.speakClick)
              : _wrapTap(Icon(Icons.clear, size: 22, color: Colors.grey), () {
                  setState(() {
                    _controller.clear();
                  });
                  _onChanged('');
                })
        ],
      ),
    );
  }

  _onChanged(String text) {
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }

    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }
}
