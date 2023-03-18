// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class PageKehadiran extends StatefulWidget {
  const PageKehadiran({super.key});

  @override
  State<PageKehadiran> createState() => _PageKehadiranState();
}

class _PageKehadiranState extends State<PageKehadiran> {
  String textTanggal = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
            child: Column(
              children: [
                Text(
                  'Kehadiran',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 13,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: HexColor('#13542D'),
                    onPressed: () {
                      DatePicker.showPicker(context,
                          pickerModel: CustomMonthPicker(
                            currentTime: DateTime.now(),
                            minTime: DateTime(2020, 1, 1),
                            maxTime: DateTime.now(),
                          ), onConfirm: (val) {
                        setState(() {
                          textTanggal = DateFormat('MMMM yyyy').format(val);
                        });
                        print(val);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pilih Bulan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          FontAwesomeIcons.calendar,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  textTanggal,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomMonthPicker extends DatePickerModel {
  CustomMonthPicker(
      {required DateTime currentTime,
      DateTime? minTime,
      DateTime? maxTime,
      LocaleType? locale})
      : super(
            locale: locale,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}
