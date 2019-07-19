import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:travel/dao/home_dao.dart';
import 'package:travel/model/common_model.dart';
import 'package:travel/model/grid_nav_model.dart';
import 'package:travel/model/home_model.dart';
import 'package:travel/model/sales_box_model.dart';
import 'package:travel/model/search_model.dart';
import 'package:travel/pages/search_page.dart';
import 'package:travel/util/navigator_util.dart';
import 'package:travel/widget/grid_nav.dart';
import 'package:travel/widget/loading_container.dart';
import 'package:travel/widget/local_nav.dart';
import 'package:travel/widget/sales_box.dart';
import 'package:travel/widget/search_bar.dart';
import 'package:travel/widget/sub_nav.dart';
import 'package:travel/widget/webview.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEATCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double appBarAlpha = 0;

  String resultString = '';
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  List<CommonModel> bannerList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: LoadingContainer(
          isLoading: _loading,
          child: Stack(
            children: <Widget>[
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: RefreshIndicator(
                  onRefresh: loadData,
                  child: NotificationListener(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification &&
                          scrollNotification.depth == 0) {
                        _onScroll(scrollNotification.metrics.pixels);
                      }
                    },
                    child: _listView(),
                  ),
                ),
              ),
              _appBar()
            ],
          ),
        ));
  }

  Widget _appBar() {

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000),Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2 ? SearchBarType.homeLight : SearchBarType.home,
              inputButtonClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEATCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {

              },
            ),
          ),
        ),
        Container(
          height: appBarAlpha>0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]
          ),
        )
      ],
    );
    /*return Opacity(
      opacity: appBarAlpha,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('首页'),
          ),
        ),
      ),
    );*/
  }

  ListView _listView() {
    return ListView(
      children: <Widget>[
        _banner(),
        Padding(
          padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(
            localNavList: localNavList,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: GridNav(
            gridNavModel: gridNavModel,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SubNav(
            subNavList: subNavList,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SalesBox(
            salesBox: salesBoxModel,
          ),
        )
      ],
    );
  }

  Container _banner() {
    return Container(
      height: 160,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        pagination: SwiperPagination(),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Image.network(bannerList[index].icon, fit: BoxFit.fill),
            onTap: () {
              NavigatorUtil.push(
                  context,
                  WebView(
                    url: bannerList[index].url,
                    title: bannerList[index].title,
                    hideAppBar: bannerList[index].hideAppBar,
                  ));
            },
          );
        },
      ),
    );
  }

  void _onScroll(double offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  Future<void> loadData() async {
    HomeModel homeModel = await HomeDao.fetch();
    setState(() {
      resultString = json.encode(homeModel.config);
      localNavList = homeModel.localNavList;
      gridNavModel = homeModel.gridNav;
      subNavList = homeModel.subNavList;
      salesBoxModel = homeModel.salesBox;
      bannerList = homeModel.bannerList;
      _loading = false;
    });
    return null;
  }

  void _jumpToSearch() {
    NavigatorUtil.push(context, SearchPage(
      hint: SEATCH_BAR_DEFAULT_TEXT,
    ));
  }

  void _jumpToSpeak() {

  }
}
