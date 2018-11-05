import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:godeals_agen/bloc/app.bloc.dart';
import 'package:godeals_agen/config/api.config.dart';
import 'package:godeals_agen/config/style.config.dart';
import 'package:intl/intl.dart';
import 'package:godeals_agen/forms/opportunity_form.dart';
import 'package:map_view/figure_joint_type.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/polygon.dart';

const API_KEY = "AIzaSyAJTfjIwyfcQhfYtxbVoNkKipNQPznVELo";

class NewOpportunityPage extends StatefulWidget {
  static const String routeName = '/new-opportunity';

  @override
  NewOpportunityPageState createState() => NewOpportunityPageState();
}

class NewOpportunityPageState extends State<NewOpportunityPage> {

  final AsyncMemoizer _memoizer = AsyncMemoizer();
  bool isData = false;
  dynamic data;

  @override
  void didChangeDependencies() {
    fetchDataList(context).then((val){
      data = val;
      isData = true;
      setState((){
        print('data updated');
      });
    });
    super.didChangeDependencies();
  }

  TextEditingController controller = new TextEditingController();

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      title: Text("Create Opportunity"),
      elevation: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: _createAppBar(context),
      body: isData ? NewOpportunityForm(data: data) : Center(child: CircularProgressIndicator())
//      body: NewOpportunityForm(data: {'rooms': [{'id':'1'}]})
    );
  }

  Future<dynamic> fetchDataList(BuildContext context) async {
    return this._memoizer.runOnce(() async {
      final AppBloc appBloc = AppBlocProvider.of(context);
      Response response = await appBloc.app.api.get(
        Api.routes[ApiRoute.areas],
//        data: fields,
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );

      Response response2 = await appBloc.app.api.get(
        Api.routes[ApiRoute.rooms],
//        data: fields,
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );


      return {
        'areas': response.data['data'],
        'rooms': response2.data['data'],
      };
    });
  }
}

class NewOpportunityForm extends StatefulWidget {
  final dynamic data;
  const NewOpportunityForm({Key key, this.data}): super(key: key);


  @override
  NewOpportunityState createState() {
    MapView.setApiKey(API_KEY);
//    if (weighEntryToEdit != null) {
//      return new WeightEntryDialogState(weighEntryToEdit.dateTime,
//          weighEntryToEdit.weight, weighEntryToEdit.note);
//    } else {
//      return new WeightEntryDialogState(
//          new DateTime.now(), initialWeight, null);
//    }
    return new NewOpportunityState();
  }
}

class NewOpportunityState extends State<NewOpportunityForm> {
  MapView mapView = new MapView();
  Uri staticMapUri;
  CameraPosition cameraPosition;
  var compositeSubscription = new CompositeSubscription();
  List<dynamic> areas = [];

  final OpportunityForm _opportunityForm = OpportunityForm();
  List<dynamic> sevices = [];
//  List<dynamic> sevicesPilihan = ['wifi', 'free_breakfast', 'tv', 'pool', 'restaurant'];
  List<dynamic> areasPilihan = [];
  List<dynamic> sevicesPilihan = [];


  @override
  initState() {
    super.initState();
    cameraPosition = new CameraPosition(Locations.portland, 2.0);
//    _opportunityForm.fetchDataList(context).then((value) {
//      setState(() {
//        areas = value['areas'];
//        print(value['rooms']);
//        print('ngeseng');
//        sevicesPilihan = value['rooms'];
//      });
//    });
  }

  @override
  void dispose() {
    _opportunityForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => SingleChildScrollView(
        child: new Container(
          //          constraints: BoxConstraints(
          //            minHeight: MediaQuery.of(context).size.height,
          //          ),
          child: new SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildRegisterForm(context),
                _buildRegisterButton(context),
              ],
            )
          ),
        ),
      )
    );
  }

  /// Register Form with the box
  Widget _buildRegisterForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 18.0,
        top: 8.0,
      ),
      child: Form(
        key: _opportunityForm.key,
        child: StreamBuilder<Map<String, dynamic>>(
          stream: _opportunityForm.errors,
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 15.0),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Flexible(
                      child: new Column(
                        children: <Widget>[
                          new _DateTimePicker(
                            labelText: 'CHECK-IN',
                            selectedDate: _opportunityForm.fields['checkInDate'],
                            selectDate: (DateTime date) {
                              setState(() {
                                _opportunityForm.fields['checkInDate'] = date;
                              });
                            },
                          ),
                          _buildErrorText(snapshot, 'checkInDate')
                        ]
                      )
                    ),
                    new Container(width: 8.0,),
                    new Flexible(
                      child: new Column(
                        children: <Widget>[
                          new _DateTimePicker(
                            labelText: 'CHECK-OUT',
                            selectedDate: _opportunityForm.fields['checkOutDate'],
                            selectDate: (DateTime date) {
                              setState(() {
                                _opportunityForm.fields['checkOutDate'] = date;
                              });
                            },
                          ),
                          _buildErrorText(snapshot, 'checkOutDate')
                        ]
                      )
                    )
                  ],
                ),
                Container(height: 15.0),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Flexible(
                      child: new Column(
                         children: <Widget>[
                           new Text('Number Of Rooms'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey),),
                           new Container(height: 8.0,),
                           new Container(
                               padding: EdgeInsets.only(left: 15.0, right: 35.0, top: 5.0, bottom: 5.0),
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(5.0),
                                   color: Colors.white
                               ),
                               child: TextFormField(
                                 keyboardType: TextInputType.phone,
                                 decoration: InputDecoration(
                                   border: InputBorder.none,
                                   isDense: true,
                                 ),
                                 onSaved: (val) {
                                   _opportunityForm.fields['roomNeeded'] = val;
                                 }
                               )
                           ),
                           _buildErrorText(snapshot, 'roomNeeded')
                         ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    new Container(width: 15.0,),
                    new Flexible(
                      child: new Column(
                        children: <Widget>[
                          new Text('Person / Room'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey),),
                          new Container(height: 8.0,),
                          new Container(
                              padding: EdgeInsets.only(left: 15.0, right: 35.0, top: 5.0, bottom: 5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true
                                ),
                                onSaved: (val) => _opportunityForm.fields['personPerRoom'] = val,
                              )
                          ),
                          _buildErrorText(snapshot, 'personPerRoom')
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ],
                ),
//                Container(height: 15.0),
//                new Text('City, Destination, Or Hotel Name'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey),),
//                new Container(height: 8.0,),
//                new Container(
//                    padding: EdgeInsets.only(left: 15.0, right: 35.0, top: 5.0, bottom: 5.0),
//                    decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(5.0),
//                        color: Colors.white
//                    ),
//                    child: TextFormField(
//                      keyboardType: TextInputType.phone,
//                      decoration: InputDecoration(
//                        border: InputBorder.none,
//                        isDense: true
//                      ),
//                      onSaved: (val) => _opportunityForm.fields['phoneNumber'] = val,
//                    ),
//                ),
//                _buildErrorText(snapshot, 'phoneNumber'),
                Container(height: 15.0),
                new Text('Select Services'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey),),
                Container(height: 8.0),
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
                    padding: const EdgeInsets.all(4.0),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    children: sevices.map((dynamic url) {
                      final servce = widget.data['rooms'][widget.data['rooms'].indexWhere((s) => s['id'] == url.toString() )];
                      return new GridTile(
                          child: new Column(
                            children: <Widget>[
//                              new Icon(myIcons[url], color: textGrey,),
                              Image.network(servce['imageUrl'].toString()),
                              new Text(servce['name'], style: TextStyle(color: textGrey),),
                            ],
                          ));
                    }).toList()),
                new FlatButton(
                  onPressed: () {
                    _editEntry(context);
                  },
                  padding: EdgeInsets.all(10.0),
                  child: Row( // Replace with a Row for horizontal icon + text
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("Add or Edit Services", style: TextStyle(color: warnaHijau,fontWeight: FontWeight.w600, fontSize: 16.0)),
                      Icon(Icons.chevron_right, color: warnaHijau,),
                    ],
                  ),
                ),
                Container(height: 15.0),
                new Text('NOTES'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey),),
                Container(height: 8.0),
                new Container(
                    padding: EdgeInsets.only(left: 15.0, right: 35.0, top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white
                    ),
                    child: TextFormField(
                      maxLines: 5,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true
                      ),
                      onSaved: (val) => _opportunityForm.fields['notes'] = val,
                    )
                ),
                _buildErrorText(snapshot, 'notes'),
                Container(height: 15.0),
                new Text('Area'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey),),
                Container(height: 8.0),
                new InkWell(
                  child: new Center(
                    child: new Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: _opportunityForm.fields['areaIds'].length == 0 ? new Text('No Area Selected') : new Text(_opportunityForm.fields['areaIds'].map((dynamic id) {
                        var index = areas.indexWhere((dynamic i){
                          return i['id'].toString() == id.toString();
                        });
                        return areas[index]['name'].toString();
                      }).toList().join(', ')),
                    )
                  ),
                  onTap: showMap,
                ),
                _buildErrorText(snapshot, 'areaIds'),
                new FlatButton(
                  onPressed: showMap,
                  padding: EdgeInsets.all(10.0),
                  child: Row( // Replace with a Row for horizontal icon + text
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("Add or Edit Area", style: TextStyle(color: warnaHijau,fontWeight: FontWeight.w600, fontSize: 16.0)),
                      Icon(Icons.chevron_right, color: warnaHijau,),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 18.0,
        top: 8.0,
      ),
      child: RaisedButton(
        child: Row( // Replace with a Row for horizontal icon + text
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("SUBMIT", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
          ],
        ),
        color: Theme.of(context).primaryColor,
        textTheme: ButtonTextTheme.primary,
        elevation: 0.0,
        highlightElevation: 0.0,
        onPressed: () async {
          // save form
          _opportunityForm.key.currentState.save();

          // validate then submit
          if (_opportunityForm.key.currentState.validate()) {
            await _opportunityForm.submit(context);
          }
        },
      ),
    );
  }

  _editEntry(BuildContext context) {
    Navigator
        .of(context)
        .push(
      new MaterialPageRoute<dynamic>(
        builder: (BuildContext context) {
          return new SelectServiceDialog.edit(sevices, sevicesPilihan);
        },
        fullscreenDialog: true,
      ),
    )
        .then((newSave) {
      if (newSave != null) {
//        setState(() => searchModel = newSave);
//        resend(context);
      }
    });
  }

  drawPoly() {
    mapView.setPolygons(
      areas.map((dynamic item) {
        List <dynamic>locations = item['pointCoordinates'];
        return new Polygon(
            item['id'].toString(),
            locations.map((dynamic i){
              return new Location(i['latitude'], i['longitude']);
            }).toList(),
            jointType: FigureJointType.bevel,
            strokeColor: _opportunityForm.fields['areaIds'].indexOf(item['id'].toString()) == -1 ? Colors.red : Colors.blue,
            strokeWidth: 5.0,
            fillColor: _opportunityForm.fields['areaIds'].indexOf(item['id'].toString()) == -1 ? Color.fromARGB(75, 255, 0, 0) : Color.fromARGB(75, 0, 0, 255)
        );
      }).toList()
    );
  }

  showMap() {
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            showMyLocationButton: true,
            showCompassButton: true,
            initialCameraPosition: new CameraPosition(
                new Location(21.4153424, 39.8197534), 7.0),
            hideToolbar: false,
            title: "Recently Visited"),
        toolbarActions: [new ToolbarAction("Close", 1)]);
    StreamSubscription sub = mapView.onMapReady.listen((_) {
//      mapView.setMarkers(_markers);
//      mapView.setPolylines(_lines);
      drawPoly();
    });
    compositeSubscription.add(sub);
    sub = mapView.onTouchPolygon
        .listen((polygon) {
      print("Info Window Tapped for ${polygon.id}");
      if(_opportunityForm.fields['areaIds'].indexOf(polygon.id.toString()) == -1){
        _opportunityForm.fields['areaIds'].add(polygon.id.toString());
      }
      else {
        _opportunityForm.fields['areaIds'].remove(polygon.id.toString());
      }
      drawPoly();
    });
    compositeSubscription.add(sub);
    sub = mapView.onToolbarAction.listen((id) {
      print("Toolbar button id = $id");
      if (id == 1) {
        _handleDismiss();
      }
    });
    compositeSubscription.add(sub);
  }

  _handleDismiss() async {
    double zoomLevel = await mapView.zoomLevel;
    Location centerLocation = await mapView.centerLocation;
    List<Marker> visibleAnnotations = await mapView.visibleAnnotations;
//    List<Polyline> visibleLines = await mapView.visiblePolyLines;
    List<Polygon> visiblePolygons = await mapView.visiblePolygons;
    print("Zoom Level: $zoomLevel");
    print("Center: $centerLocation");
    print("Visible Annotation Count: ${visibleAnnotations.length}");
//    print("Visible Polylines Count: ${visibleLines.length}");
    print("Visible Polygons Count: ${visiblePolygons.length}");
    setState(() {

    });
    mapView.dismiss();
    compositeSubscription.cancel();
  }

  Widget _buildErrorText(AsyncSnapshot snapshot, String f) {
    if(snapshot.hasData && snapshot.data[f].runtimeType.toString() != 'Null'){
      return new Container(
        margin: EdgeInsets.only(top: 5.0),
        child: new Text(snapshot.data[f].join(', '), style: new TextStyle(color: Colors.red[600], fontSize: 12.0)),
      );
    }
    else{
      return Container();
    }
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101)
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.subhead;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(labelText, style: TextStyle(fontSize: 14.0, color: Colors.grey),),
        new Container(height: 8.0,),
        new Container(
//                  color: Colors.white,
          padding: EdgeInsets.only(left: 12.0, right: 12.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white
          ),
          child: new _InputDropdown(
//            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () { _selectDate(context); },
          ),
        )
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
          border: InputBorder.none
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70
            ),
          ],
        ),
      ),
    );
  }
}

class SelectServiceDialog extends StatefulWidget {
  final dynamic values;
  final dynamic choice;

  SelectServiceDialog.edit(this.values, this.choice);

  @override
  SelectServiceDialogState createState() {
    return new SelectServiceDialogState(values, choice);
  }
}

class SelectServiceDialogState extends State<SelectServiceDialog> {
  List<dynamic> params;
  List<dynamic> choice;

  SelectServiceDialogState(this.params, this.choice);

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      leading: new IconButton(icon: Icon(Icons.arrow_back, color: textGrey, size: 35.0,), onPressed: (){
        Navigator.of(context).pop();
      }),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> listTiles = choice.map((dynamic item) => buildListTile(context, item));
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles, color: Colors.grey);
    List<Widget> listTilesChild = listTiles.toList();
    listTilesChild.insert(0,
      new Container(
        padding: EdgeInsets.only(left: 6.0),
        child:  new Text('Services', style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
      )
    ));
    listTilesChild.add(
      RaisedButton(
        child: Row( // Replace with a Row for horizontal icon + text
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("SUBMIT", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
          ],
        ),
        color: Theme.of(context).primaryColor,
        textTheme: ButtonTextTheme.primary,
        elevation: 0.0,
        highlightElevation: 0.0,
        onPressed: () async {
          Navigator.of(context).pop(choice);
        },
      )
    );
    return new Scaffold(
        appBar: _createAppBar(context),
        backgroundColor: Colors.blueGrey[50],
        body: new DropdownButtonHideUnderline(
          child: new SafeArea(
            top: false,
            bottom: false,
            child: new ListView(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              children: listTilesChild,
            ),
          ),
        )
    );
  }

  Widget buildListTile(BuildContext context, dynamic values) {
    return new MergeSemantics(
      child: ListTile(
//        leading: new Icon(myIcons[values.toString()], color:  params.indexOf(values) > -1 ?  warnaHijau : textGrey),
        title: new Text(values['name'].toString(), style: TextStyle(color: params.indexOf(values) > -1 ?  warnaHijau : textGrey, fontSize: 20.0),),
        trailing: params.indexOf(values) > -1 ? new Icon(Icons.done, color: warnaHijau,) : null,
        onTap: () {
          setState(() {
            int index = params.indexOf(values);
            if(index > -1){
              params.removeAt(index);
            }
            else{
              params.add(values.toString());
            }
          });
        },
      ),
    );
  }

}

class CompositeSubscription {
  Set<StreamSubscription> _subscriptions = new Set();

  void cancel() {
    for (var n in this._subscriptions) {
      n.cancel();
    }
    this._subscriptions = new Set();
  }

  void add(StreamSubscription subscription) {
    this._subscriptions.add(subscription);
  }

  void addAll(Iterable<StreamSubscription> subs) {
    _subscriptions.addAll(subs);
  }

  bool remove(StreamSubscription subscription) {
    return this._subscriptions.remove(subscription);
  }

  bool contains(StreamSubscription subscription) {
    return this._subscriptions.contains(subscription);
  }

  List<StreamSubscription> toList() {
    return this._subscriptions.toList();
  }
}
