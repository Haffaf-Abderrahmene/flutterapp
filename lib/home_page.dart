import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/NavBar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget{
  const HomePage({required this.onsignedout});
  final VoidCallback onsignedout;
  void signout() async{
    try{
      await FirebaseAuth.instance.signOut();
      onsignedout();
    }catch(e){
      print (e);
    }
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      drawer: NavBar(),
      appBar: new AppBar(

        title: new Text('Welcome'),
        actions: [
          new FlatButton(onPressed: signout,
              child: new Text('Logout',style : new TextStyle(fontSize: 17.0,color: Colors.white),),
          )
        ],
      ),
      body: new Container(
        child: new ListView.builder(
          itemCount: 5,
          itemBuilder: (context,index) {
            return new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          new Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage("image/img.png")
                                )
                            ),
                          ),
                          new SizedBox(
                            width: 10.0,
                          ),
                          new Text(
                            'anya',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(onPressed: null, icon: Icon(Icons.more_vert)
                      ),
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                    child: new Image.asset("image/img.png", fit: BoxFit.cover,)
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            new Icon(FontAwesomeIcons.heart),
                            new SizedBox(
                              width: 16.0,
                            ),
                            new Icon(FontAwesomeIcons.comment),
                            new SizedBox(width: 16.0,),
                            new Icon(FontAwesomeIcons.paperPlane),
                          ]
                      ),
                      new Icon(FontAwesomeIcons.bookmark)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "liked by noob, noob and 1694 others",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("image/img.png")),
                        ),
                      ),
                      new SizedBox(width: 10.0,),

                      Expanded(
                          child: new TextField(
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintText: "Add a comments ..."
                            ),
                          ))
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child : Text("1 day ago",style: TextStyle(color: Colors.grey),)
                )
              ],
            );
          }


            )
      )
    );
  }
}