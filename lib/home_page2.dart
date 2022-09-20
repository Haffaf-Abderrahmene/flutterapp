import 'package:flutter/material.dart';
import 'package:flutter_app/getdata.dart';

import 'NavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class homepage extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() => new homestate();
  
}
class homestate extends State<homepage>{
  @override
  Widget build(BuildContext context) {
    Data data = Data();
    void signout() async{
      try{
        await FirebaseAuth.instance.signOut();
      }catch(e){
        print (e);
      }
    }
    //fonction li tjib les posts
    Future<QuerySnapshot> getPosts() async{
      var bd = FirebaseFirestore.instance;
      return await bd.collection("posts").get();
    }
    
    return Scaffold(
      drawer: NavBar(),
      appBar: new AppBar(

      title: new Text('Home'),
      actions: [
        new FlatButton(onPressed: signout,
          child: new Text('Logout',style : new TextStyle(fontSize: 17.0,color: Colors.white),),
        )
      ],
    ),
      body: FutureBuilder(
        future: getPosts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),);
            default:
              return Container(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(
                              future: data.getuserwithid(document.get("user")),
                              builder:  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot2){
                                if(snapshot2.hasError)
                                return new Text('Error: ${snapshot2.error}');
                                switch (snapshot2.connectionState) {
                                  case ConnectionState.waiting:
                                    return Center(
                                      child: CircularProgressIndicator(),);
                                  default:
                                    return Container();
                                }
                            })
                          ],
                        )
                      ],
                    );
                  }).toList()
                ),
              );
          }
        },
        
      ),
    );
  }
  
}