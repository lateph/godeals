import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:godeals_agen/base/form.dynamic.dart';
import 'package:godeals_agen/bloc/app.bloc.dart';
import 'package:godeals_agen/config/api.config.dart';
import 'package:godeals_agen/helpers/block_loader.dart';
import 'package:godeals_agen/pages/auth/verify_member.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class OpportunityForm extends DynamicForm {
  OpportunityForm() {
    fields.addAll(<String, dynamic>{
      'checkInDate': new DateTime.now(),
      'checkOutDate': new DateTime.now(),
      'notes': '',
      'areaIds': [],
      'personPerRoom': '',
      'roomNeeded': ''
    });
  }

  @override
  Future<Null> submit(BuildContext context) async {
    blockLoader(context);
    final AppBloc appBloc = AppBlocProvider.of(context);
    try {
      Response response = await appBloc.app.api.post(
        Api.routes[ApiRoute.newOpportunity],
        data: {
          'checkInDate': new DateFormat('y-MM-dd', 'en').format(fields['checkInDate']),
          'checkOutDate': new DateFormat('y-MM-dd', 'en').format(fields['checkOutDate']),
          'notes': fields['notes'].toString(),
          'areaIds': fields['areaIds'],
          'personPerRoom': fields['personPerRoom'].toString(),
          'roomNeeded': fields['roomNeeded'].toString()
        },
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );

      // push member verification, and dispose all route before

      Navigator.of(context).pop();
      Navigator.of(context).pop(true);
    } on DioError catch (e) {
      // on 400 error
      if (e.response != null) {
        print(e.response.data.toString());
        errorMessages = e.response.data['data'];
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Check your input"),
        ));
      } else {
        print(e.message);
        print("Please check your internet connection");
      }

      // pop the loader
      Navigator.of(context).pop();
    }
  }

  Future<dynamic> fetchDataList(BuildContext context) async {
    final AppBloc appBloc = AppBlocProvider.of(context);
    print('test 2');
    print(appBloc.auth.deviceState.accessToken);
    try {
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
//      return {};

      // push member verification, and dispose all route before
      Navigator.of(context).pushNamedAndRemoveUntil(
          VerifyMemberPage.routeName, (Route<dynamic> route) => false);
    } on DioError catch (e) {
      // on 400 error
      print(e.response);
      Exception('Failed to load data');
    }
  }
}
