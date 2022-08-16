import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app/getdata.dart';
import 'package:flutter_app/storage_service.dart';

class AddPost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AddPostState();
}
class AddPostState extends State<AddPost>{
  late String description="";
  Data data =Data();
  Storage storage = Storage();
  var img ="";
  late String fileName;
  final formKey = new GlobalKey<FormState>();

  void initState() {
    super.initState();
    print("init");
    setState((){
      img="image/addimage.png";
      print(img);
    });
  }
  void changerpost() async{
    final user =await data.getuser();
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
      fileName ='Posts/'+user.get("name")+"/post1";
      File file = File(path!);
      
      final storageref = FirebaseStorage.instance;
      await storageref.ref(fileName).putFile(file);
      final String url = await storage.downloadfile(fileName);
      setState((){
        img=url;
      });
    }
    
  }

  void addpost() async{
    final form = formKey.currentState;
    form?.save();
    final user =await data.getuser();
    final post = {
      "image": fileName,
      "description": description,
      "user":user.id
    };
    var bd = FirebaseFirestore.instance;
   await bd.collection("posts").doc().set(post);

  }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        title: Text("Add Post"),
      ),
      body: new Container(
        child:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlatButton(
              height: 200,
              color: Colors.grey,
              onPressed:changerpost,
              padding: EdgeInsets.all(0.0),
              child: img =="image/addimage.png"?
              Image.asset(img,fit: BoxFit.fitHeight,):Image.network(img,fit: BoxFit.fitHeight,)
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add a Description ..."
                ),
                onSaved: (value)=>description=value!,
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 0.0),
              child: ElevatedButton(

                  onPressed: addpost,
                child: new Text("Add",style: TextStyle(color: Colors.white)),
                style: ButtonStyle(

                  backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)
                        )
                    ),

                )
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}