// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aplikasi_presensi/Pages/Izin/pulang_awal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MenuIzin extends StatefulWidget {
  const MenuIzin({super.key});

  @override
  State<MenuIzin> createState() => _MenuIzinState();
}

class _MenuIzinState extends State<MenuIzin> {

  void pindahKeFormPulangAwal(){
    Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) {
        return const PulangLebihAwal();
      }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
              child: Column(
                children: [
                  Text(
                    'MENU IZIN',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () => pindahKeFormPulangAwal(),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.greenAccent),
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('PULANG LEBIH AWAL'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.greenAccent),
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('MENINGGALKAN KANTOR SEMENTARA'),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.greenAccent),
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('SURAT TUGAS'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
