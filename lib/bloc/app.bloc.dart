import 'dart:async';

import 'package:godeals_agen/app.local.dart';
import 'package:godeals_agen/bloc/auth.bloc.dart';
import 'package:godeals_agen/states/device.state.dart';
import 'package:godeals_agen/states/member.state.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBlocProvider extends InheritedWidget {
  final AppBloc appBloc;

  AppBlocProvider(this.appBloc, {@required Widget child, Key key})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(AppBlocProvider oldWidget) => true;

  static AppBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AppBlocProvider)
            as AppBlocProvider)
        .appBloc;
  }
}

class AppBloc {
  final App app;

  /// common SharedPreferences for ease of use
  final SharedPreferences sharedPreferences;

  final AuthBloc auth;

  String lang;

  bool isLoadedLaunch = false;

  AppBloc({
    @required this.app,
    @required this.sharedPreferences,
    @required this.auth,
    @required this.lang,
  });

  static Future<AppBloc> initial() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String lang = (sharedPreferences.getString('lang') ?? 'en');

    /// Prepare AuthBloc
    AuthBloc authBloc = AuthBloc(
      memberState: MemberState(sharedPreferences),
      deviceState: DeviceState(sharedPreferences),
    );

    return AppBloc(
      app: App(),
      sharedPreferences: sharedPreferences,
      auth: authBloc,
      lang: lang
    );
  }

  void dispose() {
    auth.dispose(); // dispose authBloc streams
  }
}
