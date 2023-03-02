// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/Pages/Izin/menu_izin.dart';
import 'package:aplikasi_presensi/Pages/home_page.dart';
import 'package:aplikasi_presensi/Pages/other_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';

class BottomNavBar extends StatefulWidget {
  final int index;
  const BottomNavBar({super.key, this.index = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: HexColor('#13542D'),
        onTap: (index) {
          _currentTabIndex = index;
        },
        currentIndex: _currentTabIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Kehadiran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Izin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Lainnya',
          ),
        ],
        iconSize: 25,    
        activeColor: HexColor('#FFA133'),
        inactiveColor: Colors.white,    
      ),
      
      tabBuilder: ((context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomePage(),
              );
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomePage(),
              );
            });

          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: MenuIzin(),
              );
            });
          case 3:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: OtherPage(),
              );
            });
          default:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomePage(),
              );
            });
        }
      }),
    );
  }
}
