// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:aplikasi_presensi/models/pegawai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class TeamSaya extends StatefulWidget {
  const TeamSaya({super.key});

  @override
  State<TeamSaya> createState() => _TeamSayaState();
}

class _TeamSayaState extends State<TeamSaya> {
  List<apiRutanPegawai> bawahan = [];
  UserService db = UserService();
  bool isLoading = true;
  bool isError = false;
  bool adaBawahan = false;

  @override
  void initState() {
    getBawahanUser();
    super.initState();
  }

  void getBawahanUser() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      bawahan = await db.getBawahanUser(
        nik: globals.currentPegawai.nik.toString(),
      );
      setState(() {
        isLoading = false;
        adaBawahan = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

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
                  'Team Saya',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(child: cardTeamSaya()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardTeamSaya() {
    if (isLoading == false && isError == false) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: bawahan.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 5),
            padding: EdgeInsets.only(top: 10, left: 20, bottom: 10, right: 10),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bawahan[index].nama.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      bawahan[index].nik.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      bawahan[index].jabatan.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                )
              ],
            ),
          );
        },
      );
    } else if (isLoading == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
          child: Column(
        children: [
          Text("Unknown Error"),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // daftarIzin.clear();
                // getSemuaMateri();
              });
            },
            child: Text("Tap to refresh"),
          ),
        ],
      ));
    }
  }
}
