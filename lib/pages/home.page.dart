import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:godeals_agen/config/api.config.dart';
import 'package:godeals_agen/config/style.config.dart';
import 'package:godeals_agen/bloc/app.bloc.dart';
import 'package:godeals_agen/pages/opportunity/detail.page.dart';
import 'package:godeals_agen/pages/opportunity/new.page.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:timeago/timeago.dart' as timeago;
class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => new _HomePageState();
}

class DashboardAPINotifier extends ChangeNotifier {
  bool _isLoading = false;
  get getIsLoading => _isLoading;
  set setLoading(bool isLoading) => _isLoading = isLoading;
}

class _HomePageState extends State<HomePage> {
  AssetImage background = AssetImage('assets/images/home.jpg');
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  bool launch = false;
  List<dynamic> childs = [];
  String nextUrl = '';
  ScrollController controller;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  DashboardAPINotifier _dashboardAPINotifier;

  void simpanMessage (AppBloc appBloc, message) {
    print('type data');
    print(appBloc.auth.deviceState.attributes['notif'].runtimeType.toString());
    if (appBloc.auth.deviceState.attributes['notif'].runtimeType.toString() == 'List<Map<String, String>>' || appBloc.auth.deviceState.attributes['notif'].runtimeType.toString() == 'List<dynamic>' || appBloc.auth.deviceState.attributes['notif'].runtimeType.toString() == 'List<Map<String, dynamic>>'){
      appBloc.auth.deviceState.attributes['notif'].insert(0,
        {
          'title': message['title'],
          'messsage': message['message'],
          'time': message['time'],
          'detailUrl': message['detailUrl'],
          'status': false
        }
      );
    }
    else{
      appBloc.auth.deviceState.attributes['notif'] = [
        {
          'title': message['title'],
          'messsage': message['message'],
          'time': message['time'],
          'detailUrl': message['detailUrl'],
          'status': false
        }
      ];
    }
    appBloc.auth.deviceState.save();
    appBloc.auth.updateAuthStatus();
  }

  @override
  void initState() {
    super.initState();
//    fetchDataHome(context, "").then(() => {
//      setState((){
//
//      });
//    });
    _dashboardAPINotifier = DashboardAPINotifier();

    _dashboardAPINotifier.addListener(() {
      if (_dashboardAPINotifier.getIsLoading) {
        print("loading is true");
        fetchDataHome(context, nextUrl).then((value){
        }); //Hit API
      } else {
        print("loading is false");
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchDataHome(context, '').then((value){
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dashboardAPINotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = AppBlocProvider.of(context);
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
//        Scaffold.of(context).showSnackBar(new SnackBar(
//          content: new Text("New Message"),
//        ));
        simpanMessage(appBloc, message);
        print('');
//        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) {
//        Scaffold.of(context).showSnackBar(new SnackBar(
//          content: new Text("New Message Launc"),
//        ));

        if(appBloc.isLoadedLaunch == false){
          appBloc.isLoadedLaunch = true;
          simpanMessage(appBloc, message);
        }
//        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
//        Scaffold.of(context).showSnackBar(new SnackBar(
//          content: new Text("New Message Resume"),
//        ));
        simpanMessage(appBloc, message);
//        _navigateToItemDetail(message);
      },
    );
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50]
        ),
        child: RefreshIndicator(child:
          new CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: 200.0,
              elevation: 0.0,
              pinned: true,
              title: const Text('Godeals', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26.0),),
              floating: false,
              flexibleSpace: new FlexibleSpaceBar(
                background: new Container(
                  margin: const EdgeInsets.only(
                    top: 70.0,
                    right: 24.0,
                    left: 24.0,
                    bottom: 10.0,
                  ),
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Center(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text('You Have '+childs.length.toString()+' Active Opportunity', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),),
                        childs.length > 0 ? new Container(
                            margin: const EdgeInsets.only(
                              top: 10.0,
                              right: 10.0,
                              left: 10.0,
                              bottom: 10.0,
                            ),
                           padding: const EdgeInsets.only(
                             top: 10.0,
                             right: 10.0,
                             left: 10.0,
                             bottom: 10.0,
                           ),
                           decoration: BoxDecoration(
                             border: Border.all(color: Colors.white,width: 2.0),
                             borderRadius: BorderRadius.circular(13.0)
                           ),
                           child: new Text('23 Hours 57 Min', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w600),),
                        ) : new Container(
                          margin: const EdgeInsets.only(
                            top: 10.0,
                            right: 10.0,
                            left: 10.0,
                            bottom: 10.0,
                          ),
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            right: 10.0,
                            left: 10.0,
                            bottom: 10.0,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white,width: 2.0),
                              borderRadius: BorderRadius.circular(13.0)
                          ),
                          child: new Text('00 Hours 00 Min', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w600),),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ),
            StreamBuilder(
              stream: appBloc.auth.status,
              builder: (context, snapshot) {
                return
                  SliverList(
                    delegate: new SliverChildBuilderDelegate(
                      (context, index) {
                      if (index == childs.length - 1 && nextUrl != null) {
                        return _reachedEnd();
                      } else {
                        return _buildCard(context, index);
                      }
                    },
                    childCount: childs.length,
                  )
                );
              }
            ),
            new SliverList(
              delegate: SliverChildListDelegate([
                new Padding(padding: EdgeInsets.only(top: 80.0))
              ])
            ),
          ]
        )
        , onRefresh: refreshList, key: refreshKey,)
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget> [
            new DrawerHeader(child: new Text('Header'),),
            new ListTile(
              title: new Text('First Menu Item'),
              onTap: () {},
            ),
            new ListTile(
              title: new Text('Second Menu Item'),
              onTap: () {},
            ),
            new Divider(),
            new ListTile(
              title: new Text('About'),
              onTap: () {},
            ),
          ],
        )
      ),
      floatingActionButton: Builder(
        builder: (context) => new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.add),
          backgroundColor: warnaHijau,
          onPressed:  () async  {
            final value = await Navigator.of(context).pushNamed(NewOpportunityPage.routeName);
            if(value.toString() == 'true'){
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text("Opportunity has been saved"),
              ));
            }
          }
        )
      ),
    );
  }

  Widget _buildCard(BuildContext context, index) {
    if(childs[index]['status'] == 'active'){
      return _buildOnBidding(context, index);
    }
    else if(childs[index]['status'] == 'completed'){
      return _buildComplete(context, index);
    }
    else{
      return _buildCanceledOnBidding(context);
    }
//    if (index == 0){
//      return _buildOnBidding(context);
//    }
//    else if(index == 1){
//      return _buildCanceledOnBidding(context);
//    }
//    else{
//      return _buildComplete(context);
//    }
  }
  Widget _buildOnBidding(BuildContext context, int index) {
    var value = childs[index];
    Map<String, dynamic> lokasi = new Map<String, dynamic>.from(value['areaNames']);

    if(value['offerByStatus'].toString() == '[]'){
      value['offerByStatus'] = {};
    }
    Map<String, int> accepted = new Map<String, int>.from(value['offerByStatus']['accepted'] != null ? value['offerByStatus']['accepted'] : {});
    int totalWaiting = 0;
    accepted.values.toList().forEach((num e){totalWaiting += e;});

    Map<String, int> confirmed = new Map<String, int>.from(value['offerByStatus']['confirmed'] != null ? value['offerByStatus']['confirmed'] : {});
    int totalConfirmed = 0;
    confirmed.values.toList().forEach((num e){totalConfirmed += e;});

    Map<String, int> news = new Map<String, int>.from(value['offerByStatus']['new'] != null ? value['offerByStatus']['new'] : {});
    int totalNew = news.values.toList().length;

//    news.values.toList().forEach((num e){totalNew += e;});
    String textAgo = timeago.format(DateTime.parse(value['checkInDate']), allowFromNow: true, locale: 'en');
    print(textAgo);
//    accepted.values.reduce((a, b) => a +) b
    return Container(
      margin: const EdgeInsets.only(
        top: 10.0,
        right: 10.0,
        left: 10.0,
        bottom: 0.0,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        child: new InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailOpportunityPage(todo: value),
              ),
            );
//            Navigator.of(context).pushNamed(DetailOpportunityPage.routeName);
          },
          child: new Container(
            padding: const EdgeInsets.only(top:10.0, bottom: 10.0, left: 10.0, right: 10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                totalNew == 0 ? new Container() :  new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.error, color: warnaOranye),
                    Padding(padding: EdgeInsets.only(left: 10.0),),
                    Text(totalNew.toString() + ' New Offers',style: new TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: warnaHijau)),
                  ],
                ),
                totalNew == 0 ? new Container() : new Divider(color: Colors.grey),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 80.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: hijauMuda, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: IconButton(icon: new Icon(Icons.timer, color: hijauMuda,size: 65.0), padding: EdgeInsets.all(0.0), onPressed: () {

                      }),
                    ),
                    new Padding(padding: EdgeInsets.only(left: 5.0)),
                    new Expanded(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text('On Bidding', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                                decoration: BoxDecoration(
                                    color: hijauMuda,
                                    borderRadius: BorderRadius.circular(5.0)
                                ),
                                padding: EdgeInsets.all(4.0),
                              ),
                              new Padding(padding: EdgeInsets.only(left: 5.0)),
                              Icon(Icons.access_time, color: Colors.grey,),
                              new Padding(padding: EdgeInsets.only(left: 5.0)),
                              new Expanded(
                                child: new Text(textAgo, style: TextStyle(color: Colors.grey),textDirection: TextDirection.ltr),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.location_on, color: Colors.grey),
                              new Expanded(
                                  child: Text(lokasi.values.toList().join(', '), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: textGrey))
                              )
                            ],
                          ),
                          Text('Check in / Check out date', style: TextStyle(color: Colors.grey, fontSize: 12.0),),
                          Text(new DateFormat('y MMMM dd').format(DateTime.parse(value['checkInDate'])) + ' / ' + new DateFormat('y MMMM dd').format(DateTime.parse(value['checkOutDate'])), style: TextStyle(fontWeight: FontWeight.w600, color: textGrey),),
                          Text(value['personPerRoom'].toString() + ' Person / Room ', style: TextStyle(fontWeight: FontWeight.w600, color: textGrey),)
                        ],
                      ),
                    ),
                  ],
                ),
                new Divider(color: Colors.grey),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.hotel, color: textGrey, size: 30.0,),
                    new Container(
                      width: 1.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                          color: Colors.grey
                      ),
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Total', style: TextStyle(color: Colors.grey),),
                        Text(value['roomNeeded'].toString(), style: TextStyle(color: textGrey, fontWeight: FontWeight.w600),)
                      ],
                    ),
                    new Container(
                      width: 1.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                          color: Colors.grey
                      ),
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Confirmed', style: TextStyle(color: Colors.grey),),
                        Text(totalConfirmed.toString() , style: TextStyle(color: textGrey, fontWeight: FontWeight.w600),)
                      ],
                    ),
                    new Container(
                      width: 1.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                          color: Colors.grey
                      ),
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Waiting', style: TextStyle(color: Colors.grey),),
                        Text(totalWaiting.toString() , style: TextStyle(color: textGrey, fontWeight: FontWeight.w600),)
                      ],
                    ),
                    new Container(
                      width: 1.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                          color: Colors.grey
                      ),
                    ),
                    Text((totalConfirmed / value['roomNeeded'] * 100).round().toString() + '%', style: TextStyle(color: textGrey, fontWeight: FontWeight.w600, fontSize: 22.0))
                  ],
                )
              ],
            ),
          )
        ),
      ),
    );
  }
  Widget _buildCanceledOnBidding(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10.0,
        right: 10.0,
        left: 10.0,
        bottom: 0.0,
      ),
      padding: const EdgeInsets.only(top:10.0, bottom: 10.0, left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                    border: Border.all(color: warnaOranye, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0)
                ),
                child: IconButton(icon: new Icon(Icons.timer, color: warnaOranye,size: 65.0), padding: EdgeInsets.all(0.0), onPressed: () {

                }),
              ),
              new Padding(padding: EdgeInsets.only(left: 5.0)),
              new Expanded(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text('Canceled', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                          decoration: BoxDecoration(
                              color: warnaOranye,
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          padding: EdgeInsets.all(4.0),
                        ),
                        new Padding(padding: EdgeInsets.only(left: 5.0)),
                        Icon(Icons.access_time, color: Colors.grey,),
                        new Padding(padding: EdgeInsets.only(left: 5.0)),
                        new Expanded(
                          child: new Text('4 hrs 15 mins Remaining', style: TextStyle(color: Colors.grey),),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on, color: Colors.grey),
                        new Expanded(
                            child: Text('Makka, Madinah', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: textGrey))
                        )
                      ],
                    ),
                    Text('Start - End Reservation date', style: TextStyle(color: Colors.grey, fontSize: 12.0),),
                    Text('13 May 2018 - 18 May 2018 / 5 Days', style: TextStyle(fontWeight: FontWeight.w600, color: textGrey),),
                  ],
                ),
              ),
            ],
          ),
          new Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Total Room(s)', style: TextStyle(color: Colors.grey),),
                  Text('10 Rooms', style: TextStyle(color: textGrey, fontWeight: FontWeight.w600),)
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.grey, width: 1.0))
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Cancelation Reason', style: TextStyle(color: Colors.grey),),
                      Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ultrices ante et mollis scelerisque', style: TextStyle(color: textGrey, fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
  Widget _buildComplete(BuildContext context, int index) {
    var value = childs[index];
    String textAgo = timeago.format(DateTime.parse(value['checkInDate']), allowFromNow: true, locale: 'en');
    Map<String, dynamic> lokasi = new Map<String, dynamic>.from(value['areaNames']);

    Map<String, int> confirmed = new Map<String, int>.from(value['offerByStatus']['confirmed'] != null ? value['offerByStatus']['confirmed'] : {});
    int totalConfirmed = 0;
    confirmed.values.toList().forEach((num e){totalConfirmed += e;});

    return Container(
      margin: const EdgeInsets.only(
        top: 10.0,
        right: 10.0,
        left: 10.0,
        bottom: 0.0,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailOpportunityPage(todo: value),
              ),
            );
//            Navigator.of(context).pushNamed(DetailOpportunityPage.routeName);
          },
          child: Container(
            padding: const EdgeInsets.only(top:10.0, bottom: 10.0, left: 10.0, right: 10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 80.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: warnaGolden, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: IconButton(icon: new Icon(Icons.timer, color: warnaGolden,size: 65.0), padding: EdgeInsets.all(0.0), onPressed: () {

                      }),
                    ),
                    new Padding(padding: EdgeInsets.only(left: 5.0)),
                    new Expanded(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text('Completed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                                decoration: BoxDecoration(
                                    color: warnaGolden,
                                    borderRadius: BorderRadius.circular(5.0)
                                ),
                                padding: EdgeInsets.all(4.0),
                              ),
                              new Padding(padding: EdgeInsets.only(left: 5.0)),
                              Icon(Icons.access_time, color: Colors.grey,),
                              new Padding(padding: EdgeInsets.only(left: 5.0)),
                              new Expanded(
                                child: new Text(textAgo, style: TextStyle(color: Colors.grey),),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.location_on, color: Colors.grey),
                              new Expanded(
                                  child: Text(lokasi.values.toList().join(', '), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: textGrey))
                              )
                            ],
                          ),
                          Text('Check in / Check out date', style: TextStyle(color: Colors.grey, fontSize: 12.0),),
                          Text(new DateFormat('y MMMM dd').format(DateTime.parse(value['checkInDate'])) + ' / ' + new DateFormat('y MMMM dd').format(DateTime.parse(value['checkOutDate'])), style: TextStyle(fontWeight: FontWeight.w600, color: textGrey),),
                          Text(value['personPerRoom'].toString() + ' Person / Room ', style: TextStyle(fontWeight: FontWeight.w600, color: textGrey),)
                        ],
                      ),
                    ),
                  ],
                ),
                new Divider(color: Colors.grey),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.hotel, color: textGrey, size: 30.0,),
                    new Container(
                      width: 1.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                          color: Colors.grey
                      ),
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Total', style: TextStyle(color: Colors.grey),),
                        Text(value['roomNeeded'].toString(), style: TextStyle(color: textGrey, fontWeight: FontWeight.w600),)
                      ],
                    ),
                    new Container(
                      width: 1.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                          color: Colors.grey
                      ),
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Confirmed', style: TextStyle(color: Colors.grey),),
                        Text(totalConfirmed.toString(), style: TextStyle(color: textGrey, fontWeight: FontWeight.w600),)
                      ],
                    ),
                    new Container(
                      width: 1.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                          color: Colors.grey
                      ),
                    ),
                    Text((totalConfirmed / value['roomNeeded'] * 100).round().toString() + '%', style: TextStyle(color: textGrey, fontWeight: FontWeight.w600, fontSize: 22.0))
                  ],
                ),
                new Divider(color: Colors.grey),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(left: 12.0, right: 20.0),
                      child: Icon(Icons.monetization_on, color: textGrey, size: 30.0,),
                    ),
                    new Container(
                      width: 1.0,
                      margin: EdgeInsets.only(right: 20.0),
                      height: 30.0,
                      decoration: new BoxDecoration(
                          color: Colors.grey
                      ),
                    ),
                    Text(formatter.format(value['total']).toString()+' SAR ', style: TextStyle(color: textGrey, fontWeight: FontWeight.w600, fontSize: 22.0))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future fetchDataHome(BuildContext context, String url) async {
    final AppBloc appBloc = AppBlocProvider.of(context);
    print(appBloc.auth.deviceState.accessToken);
    try {
      Response response = await appBloc.app.api.get(
        url == '' ? Api.routes[ApiRoute.opportuniryList] : url,
        data: {
          'checkInDate' : new DateFormat('y-MM-dd', 'en').format(new DateTime.now())
        },
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );



      List<dynamic> list = response.data['data'];
      await Future.forEach(list, (e) async {
        if(e['status'].toString() == 'completed'){
          final Response details = await appBloc.app.api.get(
            '/offer/list',
            data: {
              'opportunityId': e['id']
            },
            options: Options(
              contentType: ContentType.JSON,
              headers: {
                'Authorization': appBloc.auth.deviceState.bearer,
              },
            ),
          );
          final List<dynamic> offers = details.data['data'];
          e['total'] = offers.reduce((a, b) => a['totalPrice'] + b['totalPrice']);
        }
      });

      setState(() {
        if(url == ''){
          childs.clear();
        }
        childs.addAll(list);
        nextUrl = response.data['meta']['links']['next'];
        _dashboardAPINotifier.setLoading = false;
        _dashboardAPINotifier.notifyListeners();
      });
//      if(nextUrl == null){
//        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("No more data found")));
//      }
    } on DioError catch (e) {
      // on 400 error
      print(e.response);
      Exception('Failed to load data');
    }
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await fetchDataHome(context, '');

    return null;
  }
  Widget _reachedEnd() {
    print(nextUrl);
    if (nextUrl != null) {
      print("Loading data");
      _dashboardAPINotifier.setLoading = true;
      _dashboardAPINotifier.notifyListeners();
      return const Padding(
        padding: const EdgeInsets.all(20.0),
        child: const Center(
          child: const CircularProgressIndicator(),
        ),
      );
    } else {
      print("Tak pernah dipanggil wtf");
      _dashboardAPINotifier.setLoading = false;
      _dashboardAPINotifier.notifyListeners();

    }
  }
}

class DismissDialogAction {
}
