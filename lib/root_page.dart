import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/home_page.dart';
import 'package:flutter_app/layout_bottom.dart';
import 'login_page.dart';

class RootPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus{
  notsignedin,
  signedin
}

class _RootPageState extends State<RootPage>{

  AuthStatus _auth = AuthStatus.notsignedin;

  @override
  void initState()  {
    super.initState();
    var current =  FirebaseAuth.instance.currentUser;
    setState((){
      _auth = current?.uid == null ? AuthStatus.notsignedin : AuthStatus.signedin;
    });
  }

  void _signedin(){
    setState((){
      _auth =AuthStatus.signedin;
    });
  }
  void _onsignedout(){
    setState((){
      _auth =AuthStatus.notsignedin;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_auth){
      case AuthStatus.notsignedin: return new LoginPage(onsignedin: _signedin,);
      case AuthStatus.signedin : return new layout();
    }

  }
}