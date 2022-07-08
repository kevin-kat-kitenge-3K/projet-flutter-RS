import 'dart:async';

import 'package:flutter/material.dart';
import 'package:picha/controller/loading_controller.dart';
import 'package:picha/util/firebase_handler.dart';

import '../model/Member.dart';

class MainController extends StatefulWidget {

  String memberUid;
  MainController({required this.memberUid});

  @override
  State<StatefulWidget> createState() => MainState();
}

class MainState extends State<MainController> {

   late StreamSubscription streamSubscription;
   late Member member;

  @override
  void iniState() {
    // TODO:implement initState
    super.initState();
    //Recuperer user a partir de uid

    streamSubscription =
        FirebaseHandler().fire_user.doc(widget.memberUid).snapshots().listen((
            event) {
          setState(() {
            member = Member(event);
          });
        });
  }


  @override
  Widget build(BuildContext context) {
    return (member == null)
             ? LoadingController()
        :Scaffold(
      appBar: AppBar(title: Text("Salut"),),
      body: Center(child: Text("Salut bro ${member.surname} ${member.name}"),),
    );
  }
}
