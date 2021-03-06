import 'dart:async';
import 'dart:io';

import 'package:godeals_agen/base/form.base.dart';
import 'package:godeals_agen/bloc/app.bloc.dart';
import 'package:godeals_agen/config/api.config.dart';
import 'package:godeals_agen/helpers/block_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class VerifyDeviceForm extends BaseForm {
  VerifyDeviceForm() {
    fields.addAll(<String, String>{
      'code': '',
    });
  }

  @override
  Future<Null> submit(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);

    try {
      Response response = await appBloc.app.api.post(
        Api.routes[ApiRoute.authVerifyDevice],
        data: fields,
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );
      print(response.data);

      appBloc.auth.deviceState.attributes['isVerified'] = 'yes';
      appBloc.auth.deviceState.save();
      appBloc.auth.updateAuthStatus();

      // push member verification, and dispose all route before
      Navigator
          .of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } on DioError catch (e) {
      // on 400 error
      if (e.response != null) {
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

  Future<Null> resend(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);

    try {
      Response response = await appBloc.app.api.get(
        Api.routes[ApiRoute.authVerifyDevice],
        options: Options(
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );
      print(response.data);
      errorMessages = Map<String, dynamic>();
    } on DioError catch (e) {
      // on 400 error
      if (e.response != null) {
        print(e.response.data.toString());
        errorMessages = e.response.data['data'];
      } else {
        print(e.message);
        print("Please check your internet connection");
      }
    }

    // pop the loader
    Navigator.of(context).pop();
  }
}
