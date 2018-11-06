import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color warnaHijau = Color(0xff229c5f);
const Color warnaOranye = Color(0xfffe5722);
const Color hijauMuda = Color(0xff98d755);
const Color textGrey = Color(0xff545454);
const Color warnaGolden = Color(0xfffaaf32);
final formatter = new NumberFormat("#,###");

final ThemeData aksaraPayDefaultTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: warnaHijau,
  fontFamily: 'Proxima',
);

const myIcons = <String, IconData> {
  'wifi': Icons.wifi,
  'free_breakfast': Icons.free_breakfast,
  'tv': Icons.tv,
  'pool': Icons.pool,
  'restaurant': Icons.restaurant,
};