import 'dart:async';

import 'package:flutter/material.dart';
import 'package:godeals_agen/config/style.config.dart';
import 'package:intl/intl.dart';
import 'package:godeals_agen/forms/opportunity_form.dart';

class NewOpportunityPage extends StatefulWidget {
  static const String routeName = '/new-opportunity';

  @override
  NewOpportunityState createState() {
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

class NewOpportunityState extends State<NewOpportunityPage> {
  final OpportunityForm _opportunityForm = OpportunityForm();
  List<dynamic> sevices = ['wifi'];
  List<dynamic> sevicesPilihan = ['wifi', 'free_breakfast', 'tv', 'pool', 'restaurant'];

  @override
  void dispose() {
    _opportunityForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: _createAppBar(context),
      body: SingleChildScrollView(
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
            ),
          ),
        ),
      ),
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
            print("Has data: " + snapshot.hasData.toString());
            print("Error data: " + snapshot.data.toString());
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 15.0),
                new Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    new Flexible(
                        child: new _DateTimePicker(
                          labelText: 'CHECK-IN',
                          selectedDate: new DateTime.now(),//_opportunityForm.fields['name'],
                          selectDate: (DateTime date) {
                            setState(() {
//                      _opportunityForm.fields['name'] = val;
                            });
                          },
                        ),
                    ),
                    new Container(width: 8.0,),
                    new Flexible(
                      child: new _DateTimePicker(
                        labelText: 'CHECK-OUT',
                        selectedDate: new DateTime.now(),//_opportunityForm.fields['name'],
                        selectDate: (DateTime date) {
                          setState(() {
//                      _opportunityForm.fields['name'] = val;
                          });
                        },
                      ),
                    )
                  ],
                ),
                Container(height: 15.0),
                new Row(
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
                                   errorText: snapshot.hasData
                                       ? snapshot.data['phoneNumber']?.join(', ')
                                       : null,
                                 ),
                                 onSaved: (val) => _opportunityForm.fields['phoneNumber'] = val,
                               )
                           )
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
                                  isDense: true,
                                  errorText: snapshot.hasData
                                      ? snapshot.data['phoneNumber']?.join(', ')
                                      : null,
                                ),
                                onSaved: (val) => _opportunityForm.fields['phoneNumber'] = val,
                              )
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ],
                ),
                Container(height: 15.0),
                new Text('City, Destination, Or Hotel Name'.toUpperCase(), style: TextStyle(fontSize: 14.0, color: Colors.grey),),
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
                        errorText: snapshot.hasData
                            ? snapshot.data['phoneNumber']?.join(', ')
                            : null,
                      ),
                      onSaved: (val) => _opportunityForm.fields['phoneNumber'] = val,
                    )
                ),
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
                      return new GridTile(
                          child: new Column(
                            children: <Widget>[
                              new Icon(myIcons[url], color: textGrey,),
                              new Text(url, style: TextStyle(color: textGrey),),
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
                      Text("Add or Edxit Services", style: TextStyle(color: warnaHijau,fontWeight: FontWeight.w600, fontSize: 16.0)),
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
                        isDense: true,
                        errorText: snapshot.hasData
                            ? snapshot.data['phoneNumber']?.join(', ')
                            : null,
                      ),
                      onSaved: (val) => _opportunityForm.fields['phoneNumber'] = val,
                    )
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
  
  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      title: Text("Create Opportunity"),
      elevation: 0.0,
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
    print('kudue onok');
    print(choice);
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
  void initState() {
    super.initState();
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
        leading: new Icon(myIcons[values.toString()], color:  params.indexOf(values) > -1 ?  warnaHijau : textGrey),
        title: new Text(values.toString(), style: TextStyle(color: params.indexOf(values) > -1 ?  warnaHijau : textGrey, fontSize: 20.0),),
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