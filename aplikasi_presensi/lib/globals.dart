// import 'dart:js';

import 'package:aplikasi_presensi/models/pegawai.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quickalert/quickalert.dart';

late Pegawai currentPegawai;
final pegawai = GetStorage();

void showAlertWarning({
  String title = "Oops!",
  String message = "",
  required var context,
}) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: title,
      text: message,
      confirmBtnText: 'OK',
      confirmBtnColor: Colors.blueAccent);
}

void showAlertBerhasil({
  String title = "Berhasil",
  String message = "",
  required var context,
}) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: title,
      text: message,
      confirmBtnText: 'OK',
      confirmBtnColor: Colors.blueAccent);
}

void showAlertError({
  String title = "Oops!",
  String message = "",
  required var context,
}) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: title,
      text: message,
      confirmBtnText: 'OK',
      confirmBtnColor: Colors.blueAccent);
}
