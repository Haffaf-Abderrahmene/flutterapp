import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/getdata.dart';
import 'package:flutter_app/storage_service.dart';

class profile extends StatelessWidget{
  bool _show =false;
  late Offset tapXY;
  RenderBox? overlay;
  @override
  Widget build(BuildContext context) {
    final Storage storage =Storage();
    final Data data = Data();
    // ↓ hold screen size, using first line in build() method


    overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox?;
    List<Map<String,String>> listpost=[
      {
        'image':'image/img.png'
      },
      {
        'image':'image/img_1.png'
      },
      {
        'image':'image/backgrounganime.png'
      }
    ];
    return FutureBuilder(
      future: data.getuser(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError)
        return new Text('Error: ${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator(),);
        default:
          return new Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.account_circle),
              title: Text("profile"),
            ),
            body: Container(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FutureBuilder(
                        future: storage.downloadfile(snapshot.data!.get("photo_profile")),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot2) {
                          if (snapshot.hasError)
                          return new Text('Error: ${snapshot2.error}');
                          switch (snapshot2.connectionState) {
                          case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator(),);
                          default:
                          return new ClipOval(
                            child: GestureDetector(
                              onTapDown: getPosition,
                              onLongPress: () async {
                                String pressed = await showMenu(
                                  items: <PopupMenuEntry>[
                                    PopupMenuItem(
                                      value: "delete",
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.delete),
                                          Text("Delete"),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: "update",
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.create),
                                          Text("Update"),
                                        ],
                                      ),
                                    ),

                                  ],
                                  context: context, position: relRectSize,


                                );
                                if (pressed == "update") {
                                  final result = await FilePicker.platform.pickFiles(
                                    allowMultiple: false,
                                    type: FileType.custom,
                                    allowedExtensions: ['jpg','png']
                                  );
                                  if(result==null){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No file selected")));
                                    return null;
                                  }else{
                                    final path =result.files.single.path;
                                    final fileName ='profile/'+ snapshot.data!.get("name")+"_profile";

                                    File file =File(path!);
                                    final storageref = FirebaseStorage.instance;
                                    await storageref.ref(fileName).putFile(file);
                                    var bd = FirebaseFirestore.instance;
                                    bd.collection("users").doc(snapshot.data!.id).update({"photo_profile":fileName});
                                  }
                                  print("update");
                                } else {
                                  print("delete");
                                }
                              },
                              child: snapshot2.connectionState==ConnectionState.done && snapshot2.hasData ?
                              Image.network(snapshot2.data!, width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ):Image.asset("image/profile.png", width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),

                            )


                          );
                        }},
                      )

                    ),
                    
                    //name 
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(snapshot.data!.get("name"),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight
                              .bold)),
                    ),
                    
                    //email
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(snapshot.data!.get("email")),
                    ),
                    
                    //description
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 10),
                      child: Text(
                          snapshot.data!.get("description")),
                    ),
                    Divider(height: 10, thickness: 1,),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1 / 1,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemBuilder: (context, index) {
                        final post = listpost[index];
                        return Container(
                          color: Colors.greenAccent,
                          child: Image.asset(
                            post['image']!, fit: BoxFit.cover,),
                        );
                      },
                      itemCount: listpost.length,
                    )
                  ],
                ),
              ),
            ),
          );
      }}
        );



  }
  RelativeRect get relRectSize => RelativeRect.fromSize(tapXY & const Size(40,40), overlay!.size);

  // ↓ get the tap position Offset
  void getPosition(TapDownDetails detail) {
    tapXY = detail.globalPosition;
  }
}