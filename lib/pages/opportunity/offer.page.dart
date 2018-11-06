import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:godeals_agen/bloc/app.bloc.dart';
import 'package:godeals_agen/config/style.config.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:godeals_agen/pages/opportunity/fancyfab.dart';

class OfferPage extends StatefulWidget {
  static const String routeName = '/contacts';

  final dynamic data;

  OfferPage(this.data);

  @override
  OfferPageState createState() {
//    if (weighEntryToEdit != null) {
//      return new WeightEntryDialogState(weighEntryToEdit.dateTime,
//          weighEntryToEdit.weight, weighEntryToEdit.note);
//    } else {
//      return new WeightEntryDialogState(
//          new DateTime.now(), initialWeight, null);
//    }
    return new OfferPageState();
  }
}

enum DialogAction {
  ignored,
  accepted,
  cancelled,
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class OfferPageState extends State<OfferPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  @override
  Widget build(BuildContext context) {
    List<dynamic> details = widget.data['details'];

    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    List<dynamic> images = widget.data['hotel']['images'];


    return Scaffold(
      key: _scaffoldKey,
//      floatingActionButton: new FancyFab(
//        onAccept: (){
//          return showDialog<Null>(
//            context: context,
//            barrierDismissible: false, // user must tap button!
//            builder: (BuildContext context) {
//              return new AlertDialog(
//                title: new Text('Confirmation'),
//                content: new SingleChildScrollView(
//                  child: new ListBody(
//                    children: <Widget>[
//                      new Text('Are your sure to Accept Offer ?'),
//                    ],
//                  ),
//                ),
//                actions: <Widget>[
//                  new FlatButton(
//                    child: new Text('Accept'),
//                    onPressed: () async {
//                      dynamic val = await cahngeStatus(context, widget.data['id'], 'accepted');
//                      Navigator.of(context).pop();
//                    },
//                  ),
//                  new FlatButton(
//                    child: new Text('Cancel'),
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                  ),
//                ],
//              );
//            },
//          );
//        },
//      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(widget.data['status'] == 'new' ) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) =>
                SimpleDialog(
                    title: const Text('Set Status'),
                    children: <Widget>[
                      _DialogDemoItem(
                          icon: Icons.done,
                          color: theme.primaryColor,
                          text: 'Accepted',
                          onPressed: () async {
                            try {
                              await cahngeStatus(
                                  context, widget.data['id'], 'accepted');
                              Navigator.pop(context, 'Data Accepted');
                              setState(() {
                                widget.data['status'] = 'accepted';
                              });
                            }
                            catch (e) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(e.toString())
                              ));
                            }
                          }
                      ),
                      _DialogDemoItem(
                          icon: Icons.clear,
                          color: theme.primaryColor,
                          text: 'Ignored',
                          onPressed: () async {
                            try {
                              await cahngeStatus(
                                  context, widget.data['id'], 'ignored');
                              Navigator.pop(context, 'Data Updated');
                              setState(() {
                                widget.data['status'] = 'ignored';
                              });
                            }
                            catch (e) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(e.toString())
                              ));
                            }
                          }
                      ),
                    ]
                ),
              )
                .then<void>((
                String value) { // The value passed to Navigator.pop() or null.
                  if (value != null) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(value)
                    ));
                  }
                });
          }
        },
        child: Icon(Icons.edit),
        backgroundColor: widget.data['status'] == 'new'  ? Colors.orange : Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: new CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: _appBarHeight,
            title:  Text(widget.data['hotel']['name'].toString()),
            flexibleSpace: FlexibleSpaceBar(
//              title: Text(widget.data['hotel']['name'].toString()),
//              centerTitle: true,
              background:  new Swiper(
                itemBuilder: (BuildContext context,int index){
                  return new Image.network(images[index]['thumbnailUrl'].toString(),fit: BoxFit.cover);
                },
                itemCount: images.length,
                pagination: new SwiperPagination()
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              _ContactCategory(
//                icon: Icons.contact_mail,
                children: <Widget>[
                  _DetailItem(
                    title: new Text('Hotel Name', style: textTheme.body1.copyWith(fontSize: 15.0)),
                    trailing: new Text(widget.data['hotel']['name'].toString(), style: textTheme.caption.copyWith(fontSize: 15.0)),
                  ),
                  _DetailItem(
                    title: new Text('Address', style: textTheme.body1.copyWith(fontSize: 15.0)),
                    trailing: new Text(widget.data['hotel']['address'].toString(), style: textTheme.caption.copyWith(fontSize: 15.0)),
                  ),
                  _DetailItem(
                    title: new Text('Star', style: textTheme.body1.copyWith(fontSize: 15.0)),
                    trailing: new StarRating(rating: double.parse(widget.data['hotel']['star'].toString()), size: 20.0,starCount: 5),
                  ),
                  _DetailItem(
                    title: new Text('Distance From Holy Mosqye', style: textTheme.body1.copyWith(fontSize: 15.0)),
                    trailing: new Text(widget.data['hotel']['distanceFromHolyMosque'].toString(), style: textTheme.caption.copyWith(fontSize: 15.0)),
                  ),
                  _DetailItem(
                    title: new Text('Area', style: textTheme.body1.copyWith(fontSize: 15.0)),
                    trailing: new Text(widget.data['hotel']['area'].toString(), style: textTheme.caption.copyWith(fontSize: 15.0)),
                  ),
                ],
              ),
              AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: _ContactCategory(
                  icon: Icons.local_hotel,
                  children: details.map((e){
                    final List<dynamic> services = e['services'];
                    return _ContactItem(
                      lines: <String>[
                        '${e['roomType']}',
                        '${e['totalRoom']} Rooms',
                        '${e['pricePerRoom']}/Rooms',
                        '${e['notes']}',
                      ],
                      services: services.length == 0 ? new Container(
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
                    );
                  }).toList(),
                ),
              ),

            ]),
          ),
        ],
      ),
      bottomNavigationBar: bottomAppBarStatus(widget.data['status'])

    );
  }

  Widget bottomAppBarStatus(String status) {
    Color cStatus = warnaHijau;
    if(status == 'new'){
      cStatus = warnaOranye;
    }
    if(status == 'ignored'){
      cStatus = Colors.deepOrange;
    }
    return new BottomAppBar(
      color: cStatus,
      shape: const CircularNotchedRectangle(),
      child: Row(
        children: <Widget>[
          MaterialButton(
            child: Text(status, style: TextStyle(color: Colors.white),),
            onPressed: () {
            },
          ),
        ],
      ),
    );
  }
}


class _ContactCategory extends StatelessWidget {
  const _ContactCategory({ Key key, this.icon, this.children }) : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              icon != null ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  width: 72.0,
                  child: Icon(icon, color: themeData.primaryColor)
              ) : Container(),
              Expanded(child: Column(children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  _ContactItem({ Key key, this.icon, this.lines, this.tooltip, this.onPressed, this.services}) :
        super(key: key);

  final IconData icon;
  final List<String> lines;
  final Widget services;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> columnChildren = lines.sublist(0, lines.length - 1).map<Widget>((String line) => Text(line)).toList();
    columnChildren.add(Text(lines.last, style: themeData.textTheme.caption));

    if(services != null)
      columnChildren.add(services);

    final List<Widget> rowChildren = <Widget>[
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren
          )
      )
    ];
    if (icon != null) {
      rowChildren.add(SizedBox(
          width: 72.0,
          child: IconButton(
              icon: Icon(icon),
              color: themeData.primaryColor,
              onPressed: onPressed
          )
      ));
    }
    return MergeSemantics(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren
          )
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  _DetailItem({ Key key, this.title, this.trailing})
      : super(key: key);

  final Widget title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> rowChildren = <Widget>[
      this.title,
      this.trailing
    ];

    return MergeSemantics(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren
          )
      ),
    );
  }
}

Future<dynamic> cahngeStatus(BuildContext context, String id, String status) async {
  final AppBloc appBloc = AppBlocProvider.of(context);
//    try {
  print('halo');
  print( {
    'id': id,
    'status': status
  });

  Response response = await appBloc.app.api.put(
    '/offer/status',
    data: {
      'id': id,
      'status': status
    },
    options: Options(
      contentType: ContentType.JSON,
      headers: {
        'Authorization': appBloc.auth.deviceState.bearer,
        'Content-Type': 'application/json'
      },
    ),
  );

  return response.data;
}


class _DialogDemoItem extends StatelessWidget {
  const _DialogDemoItem({ Key key, this.icon, this.color, this.text, this.onPressed }) : super(key: key);

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 36.0, color: color),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}