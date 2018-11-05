import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:godeals_agen/base/form.dynamic.dart';
import 'package:godeals_agen/bloc/app.bloc.dart';
import 'package:godeals_agen/config/api.config.dart';
import 'package:godeals_agen/helpers/block_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class OpportunityForm extends DynamicForm {
  OpportunityForm() {
    fields.addAll(<String, dynamic>{
      'checkInDate': new DateTime.now(),
      'checkOutDate': new DateTime.now(),
      'notes': '',
      'additionalService': [],
      'areaIds': [],
      'personPerRoom': '',
      'roomNeeded': ''
    });
  }

  @override
  Future<Null> submit(BuildContext context) async {
    blockLoader(context);
    final AppBloc appBloc = AppBlocProvider.of(context);
    print({
      'checkInDate': new DateFormat('y-MM-dd', 'en').format(fields['checkInDate']),
      'checkOutDate': new DateFormat('y-MM-dd', 'en').format(fields['checkOutDate']),
      'notes': fields['notes'].toString(),
      'areaIds': fields['areaIds'],
      'additionalService': fields['additionalService'],
      'personPerRoom': fields['personPerRoom'].toString(),
      'roomNeeded': fields['roomNeeded'].toString()
    });
    try {
      Response response = await appBloc.app.api.post(
        Api.routes[ApiRoute.newOpportunity],
        data: {
          'checkInDate': new DateFormat('y-MM-dd', 'en').format(fields['checkInDate']),
          'checkOutDate': new DateFormat('y-MM-dd', 'en').format(fields['checkOutDate']),
          'notes': fields['notes'].toString(),
          'areaIds': fields['areaIds'],
          'additionalService': fields['additionalService'],
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
        print(e.response.data['data']);
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
}
