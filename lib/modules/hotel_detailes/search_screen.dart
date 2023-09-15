import 'package:flutter/material.dart';
import 'package:flutter_hotel_booking_ui/language/appLocalizations.dart';
import 'package:flutter_hotel_booking_ui/models/hotel_list_data.dart';
import 'package:flutter_hotel_booking_ui/modules/hotel_detailes/search_type_list.dart';
import 'package:flutter_hotel_booking_ui/modules/hotel_detailes/search_view.dart';
import 'package:flutter_hotel_booking_ui/utils/themes.dart';
import 'package:flutter_hotel_booking_ui/widgets/common_appbar_view.dart';
import 'package:flutter_hotel_booking_ui/widgets/common_card.dart';
import 'package:flutter_hotel_booking_ui/widgets/common_search_bar.dart';
import 'package:flutter_hotel_booking_ui/widgets/remove_focuse.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  List<HotelListData> lastsSearchesList = HotelListData.lastsSearchesList;

  late AnimationController animationController;
  final myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: RemoveFocuse(
        onClick: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        // ignore: prefer_const_constructors
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ignore: prefer_const_constructors
            CommonAppBarView(
              iconData: Icons.close_rounded,
              onBackClick: () {
                Navigator.pop(context);
              },
              titleText: AppLocalizations(context).of("search_hotel"),
            ),
            // ignore: prefer_const_constructors
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                        Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.only(
                              left: 24, right: 24, top: 16, bottom: 16),
                          child: CommonCard(
                            color: AppTheme.backgroundColor,
                            radius: 36,
                            child: CommonSearchBar(
                              textEditingController: myController,
                              iconData: FontAwesomeIcons.search,
                              enabled: true,
                              text: AppLocalizations(context)
                                  .of("where_are_you_going"),
                            ),
                          ),
                        ),
                        SearchTypeListView(),
                        Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.only(left: 24, right: 24, top: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations(context).of("Last_search"),
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  // ignore: prefer_const_constructors
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      myController.text = '';
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations(context)
                                              .of("clear_all"),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ] +
                      getPList(myController.text.toString()) +
                      [
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 16,
                        )
                      ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getPList(String searchValue) {
    List<Widget> noList = [];
    var count = 0;
    final columCount = 2;
    List<HotelListData> custList = lastsSearchesList
        .where((element) =>
            element.titleTxt.toLowerCase().contains(searchValue.toLowerCase()))
        .toList();
    for (var i = 0; i < custList.length / columCount; i++) {
      List<Widget> listUI = [];
      for (var j = 0; j < columCount; j++) {
        try {
          final data = custList[count];
          var animation = Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Interval((1 / custList.length) * count, 1.0,
                  curve: Curves.fastOutSlowIn),
            ),
          );
          animationController.forward();
          listUI.add(Expanded(
            child: SearchView(
              hotelInfo: data,
              animation: animation,
              animationController: animationController,
            ),
          ));
          count += 1;
        } catch (e) {}
      }
      noList.add(Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: listUI,
        ),
      ));
    }
    return noList;
  }
}
