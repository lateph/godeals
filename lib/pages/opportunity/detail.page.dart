import 'package:flutter/material.dart';
import 'package:godeals_agen/config/style.config.dart';

class DetailOpportunityPage extends StatefulWidget {
  static const String routeName = '/detail-opportunity';

  @override
  DetailOpportunityState createState() {
//    if (weighEntryToEdit != null) {
//      return new WeightEntryDialogState(weighEntryToEdit.dateTime,
//          weighEntryToEdit.weight, weighEntryToEdit.note);
//    } else {
//      return new WeightEntryDialogState(
//          new DateTime.now(), initialWeight, null);
//    }
    return new DetailOpportunityState();
  }
}

class DetailOpportunityState extends State<DetailOpportunityPage> {
  List<dynamic> sevices = ['wifi', 'free_breakfast', 'tv', 'pool', 'restaurant'];
  final AssetImage _logoImage = AssetImage('assets/images/hotel.jpg');

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: warnaHijau,
          title: new Text('Tabs Demo'),
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
                child: new TabBarView(
                  children: [
                    new Container(
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
                                  child: new Text('Active until June 12, 2018', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 15.0),),
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
                                  child: new Text('Create at June 11, 2018', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 15.0),),
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
                            child: new Text('June 12, 2018 / June 18, 2018 (6 Day)', style: TextStyle(fontSize: 15.0, color: textGrey),),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 20.0, top: 10.0),
                            child: new Text('Number Of Rooms'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 20.0, top: 0.0),
                            child: new Text('10 Rooms', style: TextStyle(fontSize: 15.0, color: textGrey, fontWeight: FontWeight.w400),),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 20.0, top: 10.0),
                            child: new Text('Person / Room'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 20.0, top: 0.0),
                            child: new Text('2 / Room', style: TextStyle(fontSize: 15.0, color: textGrey, fontWeight: FontWeight.w400),),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 20.0, top: 10.0),
                            child: new Text('Max distance from almasjid almadina'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 20.0, top: 0.0),
                            child: new Text('12, Miles', style: TextStyle(fontSize: 15.0, color: textGrey, fontWeight: FontWeight.w400),),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 20.0, top: 10.0),
                            child: new Text('Includes'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
                          ),
                          sevices.length == 0 ? new Container(
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
                              children: sevices.map((dynamic url) {
                                return new GridTile(
                                    child: new Column(
                                      children: <Widget>[
                                        new Icon(myIcons[url], color: textGrey,),
                                        new Text(url, style: TextStyle(color: textGrey),),
                                      ],
                                    ));
                              }).toList()),
                          new Container(
                            padding: EdgeInsets.only(left: 20.0, top: 10.0),
                            child: new Text('notes'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 20.0, top: 0.0),
                            child: new Text('I want hotel with pet allowed', style: TextStyle(fontSize: 15.0, color: textGrey, fontWeight: FontWeight.w400),),
                          ),
                        ],
                      ),
                      color: Colors.blueGrey[50],
                    ),
                    _buildBidDialog(context),
                    new Icon(Icons.directions_bike),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBidDialog(BuildContext context) {
    return new Container(
      color: Colors.blueGrey[50],
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return _buildOnBidding(context);
        },
      ),
    );
  }

  Widget _buildOnBidding(BuildContext context) {
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
              Navigator.of(context).pushNamed(DetailOpportunityPage.routeName);
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
                                      child: Text('Bid at June 10, 2018 10:00 AM', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: textGrey))
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
                                      child: Text('Alhikan Street 13C, Makkah', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: textGrey))
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
                                      child: Text('SAR 15/Room', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: textGrey))
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
                                      child: Text('5 Available', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: textGrey))
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
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
}