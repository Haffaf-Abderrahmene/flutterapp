import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class User_List extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _UserPage();
}
class _UserPage extends State<User_List>{
  var db = FirebaseFirestore.instance;
  Future getUser() async{
    var db = FirebaseFirestore.instance;
    var qn =await db.collection("users").snapshots();

    return qn;
  }

  @override
  Widget build(BuildContext context){

    Future<String> downloadurl() async{
      final storageref = FirebaseStorage.instance.ref();
      String Downloadurl =await storageref.child("profile/img.png").getDownloadURL();
      return Downloadurl;
    }

    return Scaffold(
      appBar: AppBar(title: Text('User List'),),
      body: StreamBuilder<QuerySnapshot>(
          stream: db.collection("users").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return Center(child: CircularProgressIndicator(),);
              default:
                return
                  new ListView(
                    padding: EdgeInsets.only(bottom: 80),
                    children:
                    snapshot.data!.docs.map((DocumentSnapshot document)  {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        child: Card(
                          child: FutureBuilder<String>(
                            future: downloadurl(),
                            builder: (BuildContext context,AsyncSnapshot<String> snapshot){
                              return ListTile(
                                leading: snapshot.connectionState==ConnectionState.done && snapshot.hasData ?
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: NetworkImage(snapshot.data!),//is true
                                ) : CircleAvatar(
                                  radius: 28,
                                  backgroundImage: AssetImage("image/profile.png"),//is false
                                ),

                                title: new Text(  document['name']),
                                subtitle: new Text( document['email']),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context){
                                    return [
                                      PopupMenuItem(
                                          value: 'profile',
                                          child: Row(
                                            children: [
                                              Icon(Icons.account_circle),
                                              Padding(
                                                padding:EdgeInsets.only(left: 10.0),
                                                child: Text('profile'),
                                              ),

                                            ],
                                          )
                                      ),
                                      PopupMenuItem(
                                          value: 'message',
                                          child: Row(
                                            children: [
                                              Padding(padding:EdgeInsets.only(left: 10.0)),
                                              Icon(Icons.message),
                                              Text('message')
                                            ],
                                          )
                                      ),
                                    ];
                                  },
                                  onSelected: (String value){
                                    switch (value){
                                      case 'profile':
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text("Profile"),
                                        ));
                                        break;
                                      case 'message':
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text("message"),
                                        ));
                                        break;
                                    }
                                    print("you clicked item"+value );
                                  },
                                ) ,
                              );

                            },
                          )

                        ),
                      );
                    }).toList(),
                  );
            }
          }
      )
    );

  }
}