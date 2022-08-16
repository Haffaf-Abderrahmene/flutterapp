import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
//  LoginPage({this.onsignedin});
  const LoginPage({super.key,required this.onsignedin});
  final VoidCallback onsignedin;
  @override

  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType{
  login,
  register
}

class _LoginPageState extends State<LoginPage> {

  final formKey = new GlobalKey<FormState>();

  late String _email;
  late String _password;
  late String _name;
  FormType _formType = FormType.login;

  bool validateandsave() {

    final form = formKey.currentState;
    if(form!.validate()){
      form.save();

      return true;
    }else{
      return false;
    }

  }
  void movetoregister(){
    formKey.currentState?.reset();
    setState((){
      _formType = FormType.register;
    });

  }
  void movetologin(){
    formKey.currentState?.reset();
    setState((){
      _formType = FormType.login;
    });

  }

  void validateandsubmit() async{

    if(validateandsave()){

      try{
        if(_formType==FormType.login) {
          var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _email, password: _password);
           var id =user.user?.uid;

          print(user.user?.uid);
        }else{
          var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _email, password: _password);
          print(user.user?.uid);
          final users = <String,String>{
            "email" : _email,
            "name" : _name,
            "description":"",
            "photo_profile":"",
          };
          var uid = user.user?.uid;
           var db = FirebaseFirestore.instance;
           db.collection('users').doc(uid).set(users);

        }
        widget.onsignedin();
      }catch(e){

        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter login demo'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs()+buildSubmitButton(),
            )
        )
      ),
    );
  }

  List<Widget> buildInputs(){
    if(_formType==FormType.register) {
      return[
        new TextFormField(
          decoration: new InputDecoration(labelText: "name"),
          validator: (value) => value!.isEmpty ? 'name cant be empty' : null,
          onSaved: (value)=>_name=value!,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (value) => value!.isEmpty ? 'Email cant be empty' : null,
          onSaved: (value)=>_email=value!,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: "password"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          onSaved: (value)=>_password=value!,
          obscureText: true,
        ),
      ];
    }
    return[

      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value!.isEmpty ? 'Email cant be empty' : null,
        onSaved: (value)=>_email=value!,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: "password"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onSaved: (value)=>_password=value!,
        obscureText: true,
      ),
    ];
  }

  List<Widget> buildSubmitButton(){
    if(_formType==FormType.login) {
      return [
        new RaisedButton(
          child: new Text("login", style: new TextStyle(fontSize: 20.0),),
          onPressed: validateandsubmit,
        ),
        new FlatButton(onPressed: movetoregister,
            child: new Text(
              'Create an account', style: new TextStyle(fontSize: 20.0),))
      ];
    }else{
      return [
        new RaisedButton(
          child: new Text("Create an account", style: new TextStyle(fontSize: 20.0),),
          onPressed: validateandsubmit,
        ),
        new FlatButton(onPressed: movetologin,
            child: new Text('Have an account? Login', style: new TextStyle(fontSize: 20.0),))
      ];
    }
  }

}