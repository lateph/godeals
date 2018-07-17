import 'package:godeals_agen/bloc/app.bloc.dart';
import 'package:godeals_agen/bloc/auth.bloc.dart';
import 'package:godeals_agen/pages/auth/forgot_password.page.dart';
import 'package:godeals_agen/pages/auth/login.page.dart';
import 'package:godeals_agen/pages/auth/register.page.dart';
import 'package:godeals_agen/pages/auth/verify_device.page.dart';
import 'package:godeals_agen/pages/auth/verify_member.page.dart';
import 'package:godeals_agen/pages/home.page.dart';
import 'package:godeals_agen/pages/opportunity/detail.page.dart';
import 'package:godeals_agen/pages/opportunity/new.page.dart';
import 'package:godeals_agen/pages/profile.edit.page.dart';
import 'package:godeals_agen/pages/profile.page.dart';
import 'package:godeals_agen/pages/profile.password.page.dart';
import 'package:godeals_agen/pages/static/terms_condition.page.dart';
import 'package:flutter/widgets.dart';

import 'package:godeals_agen/pages/auth/change_phone_number.page.dart';

final routes = <String, WidgetBuilder>{
  '/': (BuildContext context) {
    AppBloc appBloc = AppBlocProvider.of(context);

    return firstScreen(appBloc.auth.status.value);
  },

  // auth module
  RegisterPage.routeName: (BuildContext context) => RegisterPage(),
  LoginPage.routeName: (BuildContext context) => LoginPage(),
  VerifyMemberPage.routeName: (BuildContext context) => VerifyMemberPage(),
  ChangePhoneNumberPage.routeName: (BuildContext context) =>
      ChangePhoneNumberPage(),
  VerifyDevicePage.routeName: (BuildContext context) => VerifyDevicePage(),
  ForgotPasswordPage.routeName: (BuildContext context) => ForgotPasswordPage(),
  ProfilePage.routeName: (BuildContext context) => ProfilePage(),
  EditProfilePage.routeName: (BuildContext context) => EditProfilePage(),
  EditPasswordPage.routeName: (BuildContext context) => EditPasswordPage(),
  // static page

  NewOpportunityPage.routeName: (BuildContext context) => NewOpportunityPage(),
  DetailOpportunityPage.routeName: (BuildContext context) => DetailOpportunityPage(),
  TermsAndConditionPage.routeName: (BuildContext context) =>
      TermsAndConditionPage(),
};

Widget firstScreen(AuthStatus authStatus) {
  if (!authStatus.isLoggedIn) {
    return LoginPage();
  }

  if (!authStatus.isMemberVerified) {
    return VerifyMemberPage();
  }
  if (!authStatus.isDeviceVerified) {
    return VerifyDevicePage();
  }

  return HomePage();
}
