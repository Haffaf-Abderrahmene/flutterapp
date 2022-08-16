

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/User_List.dart';
import 'package:flutter_app/User_page.dart';
import 'package:flutter_app/getdata.dart';
import 'package:flutter_app/storage_service.dart';
class NavBar extends StatefulWidget {


  State<StatefulWidget> createState() => new _navbar();
}

class _navbar extends State<NavBar>{

  @override
  Widget build(BuildContext context) {
    final Data data = Data();
    final Storage storage = Storage();

    return Drawer(
      child: FutureBuilder<DocumentSnapshot>(
        future : data.getuser(),
        builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),);
            default:
              return ListView(
                padding: EdgeInsets.zero,
                children: [

                  UserAccountsDrawerHeader(
                    accountName: Text(snapshot.data!.get("name")),
                    accountEmail: Text(snapshot.data!.get("email")),
                    currentAccountPicture: FutureBuilder(
                      future: storage.downloadfile(snapshot.data!.get("photo_profile")),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot2) {
                          if (snapshot.hasError)
                          return new Text('Error: ${snapshot2.error}');
                          switch (snapshot2.connectionState) {
                          case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator(),);
                          default:return new CircleAvatar(
                              child: ClipOval(
                                child: snapshot2.connectionState==ConnectionState.done && snapshot2.hasData ?
                              Image.network(snapshot2.data!, width: 90,
                                       height: 90,
                                       fit: BoxFit.cover,
                              ):Image.asset("image/profile.png", width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                              ),
                          );
                          }
                      }
                      ),

                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('image/backgrounganime.png')

                      ),
                    ),
                  ),

                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text('Favorite'),
                    onTap: () => null,
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Friends'),
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => User_List())),
                  ),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share'),
                    onTap: () => null,
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Request'),
                    onTap: () => null,
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () => null,
                  ),
                  ListTile(
                    leading: Icon(Icons.description),
                    title: Text('Policies'),
                    onTap: () => null,
                  ),
                ],
              );
          };
        }
      )

    );
  }
}