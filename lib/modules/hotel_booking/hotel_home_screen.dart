import 'package:flutter/material.dart';
import 'package:flutter_hotel_booking_ui/language/appLocalizations.dart';
import 'package:flutter_hotel_booking_ui/models/hotel_list_data.dart';
import 'package:flutter_hotel_booking_ui/modules/hotel_booking/components/filter_bar_UI.dart';
import 'package:flutter_hotel_booking_ui/modules/hotel_booking/components/map_and_list_view.dart';
import 'package:flutter_hotel_booking_ui/modules/hotel_booking/components/time_date_view.dart';
import 'package:flutter_hotel_booking_ui/modules/myTrips/hotel_list_view.dart';
import 'package:flutter_hotel_booking_ui/providers/theme_provider.dart';
import 'package:flutter_hotel_booking_ui/routes/route_names.dart';
import 'package:flutter_hotel_booking_ui/utils/enum.dart';
import 'package:flutter_hotel_booking_ui/utils/text_styles.dart';
import 'package:flutter_hotel_booking_ui/utils/themes.dart';
import 'package:flutter_hotel_booking_ui/widgets/common_card.dart';
import 'package:flutter_hotel_booking_ui/widgets/common_search_bar.dart';
import 'package:flutter_hotel_booking_ui/widgets/remove_focuse.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HotelHomeScreen extends StatefulWidget {
  const HotelHomeScreen({super.key});

  @override
  State<HotelHomeScreen> createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController _animationController;
  var hotelList = HotelListData.hotelList;
  ScrollController scrollController = new ScrollController();
  int room = 1;
  int add = 2;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 5));
  bool _isShowMap = false;

  final searchBarHeight = 158.0;
  final filterBarHeight = 52.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    scrollController.addListener(() {
      if (scrollController.offset <= 0) {
        _animationController.animateTo(0.0);
      } else if (scrollController.offset > 0.0 &&
          scrollController.offset < searchBarHeight) {
        // we need around searchBarHieght scrolling values in 0.0 to 1.0
        _animationController
            .animateTo((scrollController.offset / searchBarHeight));
      } else {
        _animationController.animateTo(1.0);
      }
    });
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RemoveFocuse(
            onClick: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: [
                _getAppBarUI(),
                _isShowMap
                    ? MapAndListView(
                        hotelList: hotelList, searchBarUI: _getSearchBarUI())
                    : Expanded(
                        child: Stack(
                          children: [
                            Container(
                              color: AppTheme.scaffoldBackgroundColor,
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: hotelList.length,
                                padding: EdgeInsets.only(
                                  top: 8 + 158 + 52.0,
                                ),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  var count = hotelList.length > 10
                                      ? 10
                                      : hotelList.length;
                                  var animation = Tween(begin: 0.0, end: 1.0)
                                      .animate(CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn)));
                                  animationController.forward();
                                  return HotelListView(
                                    callback: () {
                                      NavigationServices(context)
                                          .gotoRoomBookingScreen(
                                              hotelList[index].titleTxt);
                                    },
                                    hotelData: hotelList[index],
                                    animation: animation,
                                    animationController: animationController,
                                  );
                                },
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (BuildContext context, Widget? child) {
                                return Positioned(
                                  top: -searchBarHeight *
                                      (_animationController.value),
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: [
                                      Container(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        child: Column(
                                          children: [
                                            //hotel search view
                                            _getSearchBarUI(),
                                            // ignore: prefer_const_constructors
                                            TimeDateView(),
                                          ],
                                          //time date and no of rooms view
                                        ),
                                      ),
                                      FilterBarUI(),
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getAppBarUI() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 8, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment:
                context.read<ThemeProvider>().languageType == LanguageType.ar
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            width: AppBar().preferredSize.height + 40,
            height: AppBar().preferredSize.height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                onTap: () {
                  Navigator.pop(context);
                },
                // ignore: prefer_const_constructors
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                AppLocalizations(context).of("explore"),
                style: TextStyles(context).getTitleStyle(),
              ),
            ),
          ),
          Container(
            width: AppBar().preferredSize.height + 40,
            height: AppBar().preferredSize.height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {},
                    // ignore: prefer_const_constructors
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.favorite_border),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {
                      setState(() {
                        _isShowMap = !_isShowMap;
                      });
                    },
                    // ignore: prefer_const_constructors
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(_isShowMap
                          ? Icons.sort
                          : FontAwesomeIcons.mapMarkedAlt),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSearchBarUI() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CommonCard(
                color: AppTheme.backgroundColor,
                radius: 36,
                // ignore: prefer_const_constructors
                child: CommonSearchBar(
                  enabled: true,
                  isShow: false,
                  text: "London...",
                ),
              ),
            ),
          ),
          CommonCard(
            color: AppTheme.primaryColor,
            radius: 36,
            // ignore: prefer_const_constructors
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  NavigationServices(context).gotoSearchScreen();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.search,
                      size: 20, color: AppTheme.backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
