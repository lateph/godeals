import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:godeals_agen/AppModel.dart';
import 'package:godeals_agen/bloc/app.bloc.dart';
import 'package:godeals_agen/config/routes.config.dart';
import 'package:godeals_agen/config/style.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:godeals_agen/translation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
Future<Null> main() async {
  // set device orientation to only portrait up
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  AppBloc appBloc = await AppBloc.initial();
  AppModel appModel = await AppModel.initial();

  runApp(AksaraPayApp(appBloc, appModel));
}

class AksaraPayApp extends StatefulWidget {
  final AppBloc appBloc;
  final AppModel appModel;

  AksaraPayApp(this.appBloc, this.appModel, {Key key}) : super(key: key);

  @override
  _AksaraPayAppState createState() => _AksaraPayAppState();
}

class _AksaraPayAppState extends State<AksaraPayApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: widget.appModel,
      child: AppBlocProvider(
        widget.appBloc,
        child: ScopedModelDescendant<AppModel>(builder: (context, child, model) {
          return MaterialApp(
            locale: model.appLocal,
            localizationsDelegates: [
              const TranslationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('ar', ''), // Arabic
              const Locale('en', ''), // English
            ],
            title: 'AksaraPay',
            theme: aksaraPayDefaultTheme,
            routes: routes,
          );
        })
      )
    );
  }

  @override
  void dispose() {
    widget.appBloc.dispose();
    super.dispose();
  }
}
