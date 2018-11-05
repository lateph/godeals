import 'dart:async';
import 'dart:io';

import 'package:godeals_agen/base/form.base.dart';
import 'package:godeals_agen/bloc/app.bloc.dart';
import 'package:godeals_agen/config/api.config.dart';
import 'package:godeals_agen/config/routes.config.dart';
import 'package:godeals_agen/helpers/block_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class LoginForm extends BaseForm {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  LoginForm() {
    fields.addAll(<String, String>{
      'username': '',
      'password': '',
      'firebaseToken': '123476',
      'deviceIdentifier': '12345678',
    });
  }

  @override
  Future<Null> submit(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);

    try {
      String token = await _firebaseMessaging.getToken();

      DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      fields['deviceIdentifier'] = androidInfo.id;
      fields['firebaseToken'] = token;
      print({
        'login': fields['username'],
        'password': fields['password'],
//          'deviceIdentifier':  androidInfo.id.toString(),
//          'firebaseToken': token.toString(),
      });

      print(Api.routes[ApiRoute.authLogin]);
      Response response = await appBloc.app.api.post(
        Api.routes[ApiRoute.authLogin],
        data: {
          'login': fields['username'],
          'password': fields['password'],
//          'deviceIdentifier':  androidInfo.id.toString(),
//          'firebaseToken': token.toString(),
        },
        options: Options(
          contentType: ContentType.JSON,
          headers: {'X-Device-identifier': 'DI-DEV-10001'},
        ),
      );
      print('hasil login');
      print(response.data);

      // save accessToken
      var member = response.data['data'];
      appBloc.auth.deviceState.load();
      var dataNotif = appBloc.auth.deviceState.notif;

      appBloc.auth.memberState.loadJson(member);
      appBloc.auth.deviceState.loadJson(member['device']);
      appBloc.auth.deviceState.attributes['notif'] = dataNotif;
      if(dataNotif.runtimeType == 'null'){
        appBloc.auth.deviceState.attributes['notif'] = [];
      }

      appBloc.auth.memberState.save();
      appBloc.auth.deviceState.save();
      appBloc.auth.updateAuthStatus();

      // push member verification, and dispose all route before
      Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (Route<dynamic> route) => false,
          );
    } on DioError catch (e) {
      // on 400 error
      if (e.response != null) {
        print('hasil login error');
        print(e.response.data.toString());
        errorMessages = e.response.data['data'];
      } else {
        print(e.message);
        print("Please check your internet connection");
      }

      // pop the loader
      Navigator.of(context).pop();
    }
  }
}
