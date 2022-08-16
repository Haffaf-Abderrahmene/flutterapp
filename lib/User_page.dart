import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class User {
  var name;
  var email;
  User(this.name,this.email);
}
class User_page extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _UserPage();

}
class _UserPage extends State<User_page>{
  List<User> user =[];
  @override
   void initState() {

     var db = FirebaseFirestore.instance;
     setState((){
       var users = db.collection("users").get().then((value) =>
           value.docs.forEach((element) {
             user.add(User(element.get("name"), element.get("email")));
             print(user);
           })
       );
     });
     super.initState();
   }

  @override
  Widget build(BuildContext context) {
     print (user);
    return new Scaffold(
      appBar: AppBar(title: Text('User List'),),
      body: new ListView.builder(

          itemBuilder: (context,index){
            return ListTile(title: Text(user[index].name),
            );
          },
        itemCount: user.length,

      )
    );
  }
}