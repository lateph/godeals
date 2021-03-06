import 'package:rxdart/rxdart.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

abstract class DynamicForm {
  final Map<String, dynamic> fields = <String, dynamic>{};

  final BehaviorSubject<Map<String, dynamic>> _errors =
  BehaviorSubject<Map<String, dynamic>>();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  Stream<Map<String, dynamic>> get errors => _errors.stream;

  set errorMessages(Map<String, dynamic> data) => _errors.add(data);

  void dispose() {
    _errors.close();
  }

  Future<Null> submit(BuildContext context);
}
