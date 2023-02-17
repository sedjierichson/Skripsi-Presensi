// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
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
                    'Richson Sedjie',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('NIK : 112233'),
                  Text('Staff IT'),
                  SizedBox(
                    height: 50,
                  ),
                  MaterialButton(
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Color.fromARGB(255, 207, 207, 207),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.lock),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text('Atur PIN Login'),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 15,)
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  MaterialButton(
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Color.fromARGB(255, 207, 207, 207),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.timer),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text('Atur Jam Pengingat Presensi'),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 15,)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
