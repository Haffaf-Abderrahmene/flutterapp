import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/NavBar.dart';
import 'package:flutter_app/Profile.dart';
import 'package:flutter_app/add_post.dart';
import 'package:flutter_app/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class layout extends StatefulWidget{
  const layout({super.key});




  @override
  State<StatefulWidget> createState() =>  _layoutstate();
}

class _layoutstate extends State<layout>{



  int currentIndex =0;
 late final List screens =[
   HomePage(),
   AddPost(),
    profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: NavBar(),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index){
          setState((){
            currentIndex=index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'home'),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.add),label: "add"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),label :'Profile')

        ],
      ),
    );
  }
}