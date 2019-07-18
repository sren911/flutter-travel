import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:travel/dao/home_dao.dart';
import 'package:travel/model/common_model.dart';
import 'package:travel/model/grid_nav_model.dart';
import 'package:travel/model/home_model.dart';
import 'package:travel/model/sales_box_model.dart';
import 'package:travel/widget/grid_nav.dart';
import 'package:travel/widget/local_nav.dart';
import 'package:travel/widget/sales_box.dart';
import 'package:travel/widget/sub_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _imageUrls = [
    'https://dimg04.c-ctrip.com/images/zg0a15000000ypf1tBC70.jpg',
    'https://dimg04.c-ctrip.com/images/zg0r16000000yrvpo1109.jpg',
    'https://dimg04.c-ctrip.com/images/zg0r16000000zx6hb0CB8.jpg',
    'https://dimg04.c-ctrip.com/images/zg0216000000zgfrh0504.jpg'
  ];
  double appBarAlpha = 0;

  String resultString = '';
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;
  @override
  void initState() {
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
        body: Stack(
      children: <Widget>[
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: NotificationListener(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollUpdateNotification &&
                  scrollNotification.depth == 0) {
                _onScroll(scrollNotification.metrics.pixels);
              }
            },
            child: ListView(
              children: <Widget>[
                Container(
                  height: 160,
                  child: Swiper(
                    itemCount: _imageUrls.length,
                    autoplay: true,
                    pagination: SwiperPagination(),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(_imageUrls[index], fit: BoxFit.fill);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
                  child: LocalNav(localNavList: localNavList,),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
                  child: GridNav(gridNavModel: gridNavModel,),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
                  child: SubNav(subNavList: subNavList,),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
                  child: SalesBox(salesBox: salesBoxModel,),
                )
              ],
            ),
          ),
        ),
        Opacity(
          opacity: appBarAlpha,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Padding(padding: EdgeInsets.only(top: 20),
                child: Text('首页'),
              ),
            ),
          ),
        )
      ],
    ));
  }

  void _onScroll(double offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    }else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });

  }

  void loadData() async{

       HomeModel homeModel = await HomeDao.fetch();
       setState(() {
         resultString = json.encode(homeModel.config);
         localNavList = homeModel.localNavList;
         gridNavModel = homeModel.gridNav;
         subNavList = homeModel.subNavList;
         salesBoxModel = homeModel.salesBox;
       });
     }

}
