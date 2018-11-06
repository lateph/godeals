import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:godeals_agen/bloc/app.bloc.dart';
import 'package:godeals_agen/config/style.config.dart';
import 'package:godeals_agen/forms/opportunity_form.dart';
import 'package:godeals_agen/pages/opportunity/offer.page.dart';
import 'package:intl/intl.dart';

class DetailOpportunityPage extends StatefulWidget {
  static const String routeName = '/detail-opportunity';

  final dynamic todo;

  // In the constructor, require a Todo
  DetailOpportunityPage({Key key, @required this.todo}) : super(key: key);


  @override
  DetailOpportunityState createState() {
//    if (weighEntryToEdit != null) {
//      return new WeightEntryDialogState(weighEntryToEdit.dateTime,
//          weighEntryToEdit.weight, weighEntryToEdit.note);
//    } else {
//      return new WeightEntryDialogState(
//          new DateTime.now(), initialWeight, null);
//    }
    return new DetailOpportunityState(todo: todo);
  }
}

class DetailOpportunityState extends State<DetailOpportunityPage> {
  List<dynamic> sevices = ['wifi', 'free_breakfast', 'tv', 'pool', 'restaurant'];
  final AssetImage _logoImage = AssetImage('assets/images/hotel.jpg');
  dynamic todo;
  AsyncMemoizer _memoizer = AsyncMemoizer();


  DetailOpportunityState({Key key, @required this.todo});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: warnaHijau,
          title: new Text('Opportunity Detail'),
        ),
        body: new DefaultTabController(
          length: 3,
          child: new Column(
            children: <Widget>[
              new Container(
                constraints: BoxConstraints(maxHeight: 150.0),
                child: new Material(
                  color: Colors.white,
                  child: new TabBar(
                    indicatorColor: Colors.transparent,
                    labelColor: warnaHijau,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      new Tab(
                        child: new Text('Information'),
                      ),
                      new Tab(
                        child: new Text('Bid'),
                      ),
                      new Tab(
                        child: new Text('Deal'),
                      ),
                    ],
                  ),
                ),
              ),
              new Expanded(
                child: FutureBuilder(
                  future: loadDetail(context, todo['id']),
                  builder: (context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('Press button to start.');
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                        if (snapshot.hasError){
                          Future.delayed(new Duration(seconds: 3), (){
                            setState(() {

                            });
                          });
                          return Center(child: CircularProgressIndicator());
                        }
                        return _buildTab(snapshot.data);
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildTab(dynamic data) {
    return new TabBarView(
      children: [
        RefreshIndicator(child: _detailOpportunity(context, data), onRefresh: _handleRefresh),
        RefreshIndicator(child: _buildBidDialog(context, data), onRefresh: _handleRefresh),
        RefreshIndicator(child: _buildDealDialog(context, data), onRefresh: _handleRefresh,),
      ],
    );
  }
  Widget _detailOpportunity(BuildContext context, dynamic data) {
    final List<dynamic> services = todo['services'];
    return SingleChildScrollView (
      child: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.access_time, color: Colors.grey,size: 17.0),
                  new Padding(padding: EdgeInsets.only(left: 5.0)),
                  new Expanded(
                    child: new Text(' Active until '+new DateFormat('MMMM dd, y').format(DateTime.parse(todo['checkInDate'])), style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 15.0),),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.insert_invitation, color: Colors.grey,size: 17.0),
                  new Padding(padding: EdgeInsets.only(left: 5.0)),
                  new Expanded(
                    child: new Text(' Create at '+new DateFormat('MMMM dd, y').format(DateTime.parse(todo['createdAt'])), style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 15.0),),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            new Divider(color: Colors.grey),
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
              child: new Text('CHECK-IN', style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
            ),
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 0.0),
              child: new Text(new DateFormat('y MMMM dd').format(DateTime.parse(todo['checkInDate'])) + ' / ' + new DateFormat('y MMMM dd').format(DateTime.parse(todo['checkOutDate'])), style: TextStyle(fontSize: 15.0, color: textGrey),),
            ),
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
              child: new Text('Number Of Rooms'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
            ),
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 0.0),
              child: new Text(todo['roomNeeded'].toString()+' Rooms ', style: TextStyle(fontSize: 15.0, color: textGrey, fontWeight: FontWeight.w400),),
            ),
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
              child: new Text('Person / Room'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
            ),
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 0.0),
              child: new Text(todo['personPerRoom'].toString() + ' Person / Room ', style: TextStyle(fontSize: 15.0, color: textGrey, fontWeight: FontWeight.w400),),
            ),
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
              child: new Text('Max distance from almasjid almadina'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
            ),
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 0.0),
              child: new Text(todo['maximumHolyMosqueDistance'].toString() +' Miles', style: TextStyle(fontSize: 15.0, color: textGrey, fontWeight: FontWeight.w400),),
            ),
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
              child: new Text('Includes'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
            ),
            services.length == 0 ? new Container(
              height: 100.0,
              child: new Center(
                child: new Text('No Services Selected'),
              ),
            ) : new GridView.count(
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 4,
                childAspectRatio: 1.5,
                padding: const EdgeInsets.all(10.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: services.map((dynamic url) {
                  return new GridTile(
                      child: new Column(
                        children: <Widget>[
                          new Image.network(url['imageUrl'].toString(), width: 30.0,),
                          new Text(url['name'].toString(), style: TextStyle(color: textGrey),),
                        ],
                      ));
                }).toList()),
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
              child: new Text('notes'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
            ),
            new Container(
              padding: EdgeInsets.only(left: 20.0, top: 0.0),
              child: new Text(data['detail']['notes'], style: TextStyle(fontSize: 15.0, color: textGrey, fontWeight: FontWeight.w400),),
            ),
          ],
        ),
        color: Colors.blueGrey[50],
      ),
    );
  }

  Widget _buildBidDialog(BuildContext context, dynamic data) {
    final List<dynamic> bids = data['bids'];
    return new Container(
      color: Colors.blueGrey[50],
      child: ListView.builder(
        itemCount: bids.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildOnBidding(context, bids[index]);
        },
      ),
    );
  }

  Widget _buildDealDialog(BuildContext context, dynamic data) {
    final List<dynamic> bids = data['deals'];
    return new Container(
      color: Colors.blueGrey[50],
      child: ListView.builder(
        itemCount: bids.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildOnBidding(context, bids[index]);
        },
      ),
    );
  }

  Widget _buildOnBidding(BuildContext context, dynamic data) {
    List<dynamic> details = data['details'];
    List<String> hargaKamars = details.map((e) => 'SAR ${e['pricePerRoom']}/Room').toList();
    final AppBloc appBloc = AppBlocProvider.of(context);
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
                  builder: (context) => OfferPage(data),
                ),
              );
//            Navigator.of(context).pushNamed(DetailOpportunityPage.routeName);
            },
            child: new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.only(top:10.0, bottom: 10.0, left: 10.0, right: 10.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Material(
                          child: Image.network(
                            data['hotel']['images'][0]['thumbnailUrl'].toString(),
                            width: 80.0,
                            height: 80.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        new Padding(padding: EdgeInsets.only(left: 5.0)),
                        new Expanded(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  new Container(
                                    child: Icon(Icons.local_offer, color: Colors.grey, size: 18.0,),
                                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                  ),
                                  new Expanded(
                                      child: Text(' Bid at '+new DateFormat('y MMMM dd hh:mm').format(DateTime.parse(data['createdAt'])), style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: textGrey))
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  new Container(
                                    child: Icon(Icons.location_on, color: Colors.grey, size: 18.0,),
                                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                  ),
                                  new Expanded(
                                      child: Text(data['hotel']['address'], style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: textGrey))
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  new Container(
                                    child: Icon(Icons.local_atm, color: Colors.grey, size: 18.0,),
                                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                  ),
                                  new Expanded(
                                      child: Text(hargaKamars.join(', '), style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: textGrey))
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  new Container(
                                    child: Icon(Icons.local_hotel, color: Colors.grey, size: 18.0,),
                                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                  ),
                                  new Expanded(
                                      child: Text('${data['totalRoom']} Available', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: textGrey))
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  data['allowCancel'] == 0 ? new Container(
                    color: warnaGolden,
                    margin: EdgeInsets.only(top: 10.0),
                    padding: EdgeInsets.only(left: 10.0, top: 14.0, bottom: 14.0),
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          child: Icon(Icons.cancel, color: Colors.white, size: 20.0,),
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                        ),
                        new Text('No Cancelation', style: TextStyle(color: Colors.white, fontSize: 18.0),)
                      ],
                    ),
                  ) : new Container(
                    color: warnaGolden,
                    margin: EdgeInsets.only(top: 10.0),
                    padding: EdgeInsets.only(left: 10.0, top: 14.0, bottom: 14.0),
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          child: Icon(Icons.cancel, color: Colors.white, size: 20.0,),
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                        ),
                        new Text('No Cancelation', style: TextStyle(color: Colors.white, fontSize: 18.0),)
                      ],
                    ),
                  ),
                  new FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OfferPage(data),
                        ),
                      );
                    },
                    padding: EdgeInsets.all(10.0),
                    child: Row( // Replace with a Row for horizontal icon + text
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("Review", style: TextStyle(color: warnaHijau,fontWeight: FontWeight.w600, fontSize: 16.0)),
                        Icon(Icons.chevron_right, color: warnaHijau,),
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
  Widget _buildOnDeal(BuildContext context, dynamic data) {
    List<dynamic> details = [];
    List<String> hargaKamars = details.map((e) => 'SAR ${e['pricePerRoom']}/Room').toList();
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
//              Navigator.of(context).pushNamed(DetailOpportunityPage.routeName);
            },
            child: new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.only(top:10.0, bottom: 10.0, left: 10.0, right: 10.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Material(
                          child: Image(
                            image: _logoImage,
                            width: 80.0,
                            height: 80.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        new Padding(padding: EdgeInsets.only(left: 5.0)),
                        new Expanded(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  new Container(
                                    child: Icon(Icons.local_offer, color: Colors.grey, size: 18.0,),
                                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                  ),
                                  new Expanded(
                                      child: Text(' Bid at '+new DateFormat('y MMMM dd hh:mm').format(DateTime.parse(data['createdAt'])), style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: textGrey))
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  new Container(
                                    child: Icon(Icons.location_on, color: Colors.grey, size: 18.0,),
                                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                  ),
                                  new Expanded(
                                      child: Text(data['hotel']['address'], style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: textGrey))
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  new Container(
                                    child: Icon(Icons.local_atm, color: Colors.grey, size: 18.0,),
                                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                  ),
                                  new Expanded(
                                      child: Text(hargaKamars.join(', '), style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: textGrey))
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  new Container(
                                    child: Icon(Icons.local_hotel, color: Colors.grey, size: 18.0,),
                                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                  ),
                                  new Expanded(
                                      child: Text('${data['totalRoom']} Available', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: textGrey))
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  data['allowCancel'] == 0 ? new Container(
                    color: warnaGolden,
                    margin: EdgeInsets.only(top: 10.0),
                    padding: EdgeInsets.only(left: 10.0, top: 14.0, bottom: 14.0),
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          child: Icon(Icons.cancel, color: Colors.white, size: 20.0,),
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                        ),
                        new Text('No Cancelation', style: TextStyle(color: Colors.white, fontSize: 18.0),)
                      ],
                    ),
                  ) : new Container(
                    color: warnaGolden,
                    margin: EdgeInsets.only(top: 10.0),
                    padding: EdgeInsets.only(left: 10.0, top: 14.0, bottom: 14.0),
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          child: Icon(Icons.cancel, color: Colors.white, size: 20.0,),
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                        ),
                        new Text('No Cancelation', style: TextStyle(color: Colors.white, fontSize: 18.0),)
                      ],
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 20.0, top: 10.0),
                    child: new Text('NOTES', style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 20.0, top: 0.0),
                    child: new Text('My Hotel is the best in city', style: TextStyle(fontSize: 15.0, color: textGrey),),
                  ),
                  new FlatButton(
                    onPressed: () {
//                      _editEntry(context);
                    },
                    padding: EdgeInsets.all(10.0),
                    child: Row( // Replace with a Row for horizontal icon + text
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("Review", style: TextStyle(color: warnaHijau,fontWeight: FontWeight.w600, fontSize: 16.0)),
                        Icon(Icons.chevron_right, color: warnaHijau,),
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }


  Future<Null> _handleRefresh() async {
    this._memoizer = new AsyncMemoizer();
    setState(() {

    });
    return null;
  }

  Future<dynamic> loadDetail(BuildContext context, id) {
    return this._memoizer.runOnce(() async {
      final AppBloc appBloc = AppBlocProvider.of(context);
      print('id yang dipakek adalah ${id}');
//    try {
      Response response = await appBloc.app.api.get(
        '/opportunity/detail/${id}',
//        data: fields,
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );

      Response response2 = await appBloc.app.api.get(
        '/offer/list',
        data: {
          'opportunityId': id
        },
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );

      final List<dynamic> datas = response2.data['data'];

      return {
        'detail': response.data['data'],
        'bids': datas.where((i) => i['status'] == 'new' || i['status'] == 'accepted').toList(),
        'deals': datas.where((i) => i['status'] == 'confirmed').toList()
      };
    });
//      return {};

    // push member verification, and dispose all route before
//      Navigator.of(context).pushNamedAndRemoveUntil(
//          VerifyMemberPage.routeName, (Route<dynamic> route) => false);
//    } on DioError catch (e) {
//      // on 400 error
//      print(e.response);
//      Exception('Failed to load data');
//    }
  }
}