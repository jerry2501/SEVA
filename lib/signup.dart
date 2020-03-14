
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seva/Animations/FadeAnimation.dart';
import 'package:seva/HomePage.dart';
import 'package:seva/database.dart';

class signup extends StatefulWidget {
  signup_layout createState()=> signup_layout();

}

class signup_layout extends State<signup>
{
  String email,password,number,city,name,key;
  final GlobalKey<FormState> formkey=GlobalKey<FormState>();
  var blood_group=['A+','A-','B+','B-','O+','O-','AB+','AB-'];
  var itemSelected='A+';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Form(
          key:formkey,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeAnimation(1.2, Text("Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),)),
              SizedBox(height: 30,),
              FadeAnimation(1.5, Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]))
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                            hintText: "Name"
                        ),
                        validator:(input) {
                          if(input.isEmpty){
                            return "Please type Name";
                          }
                        },
                        onChanged: (input) => name=input ,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]))
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                            hintText: "Email"
                        ),
                        validator:(input) {
                          if(input.isEmpty){
                            return "Please type email";
                          }
                        },
                        onChanged: (input) => email=input ,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]))
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                            hintText: "Password"
                        ),
                        obscureText: true,
                        validator:(input) {
                          if(input.isEmpty){
                            return 'Please type password';
                          }
                        },
                        onChanged: (input) => password=input ,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]))
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                            hintText: "Mobile no."
                        ),
                        validator:(input) {
                          if(input.length!=10){
                            return "Please enter valid number";
                          }
                        },
                        onChanged: (input) => number=input ,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]))
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                            hintText: "City"
                        ),
                        validator:(input) {
                          if(input.length<=0){
                            return "Please enter City Name";
                          }
                        },
                        onChanged: (input) => city=input.toLowerCase() ,
                      ),
                    ),
                    Container(

                      child: DropdownButton<String>(
                        items: blood_group.map((String dropDownStringItem)
                        {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          dropDownItemSelected(newValueSelected);

                        },
                        value: itemSelected,
                        isExpanded: true,
                        icon: Icon(Icons.mode_edit),
                        elevation: 18,
                      ),
                    ),
                  ],
                ),
              )),
              SizedBox(height: 30,),
              FadeAnimation(1.8, Center(
                child: Container(
                  width: 120,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue[800]
                  ),
                  child: Center(child:FlatButton( child:Text("Sign Up", style: TextStyle(color: Colors.white.withOpacity(.7)),),
                  onPressed: (){signUp();print(email);print(password);},),
                ),
              ))),
            ],
          ),
        ),
      ),
    );
  }

  void dropDownItemSelected(String newValueSelected) {
    setState(() {

      this.itemSelected=newValueSelected;
    });
  }

  Future<void> signUp() async
  {
    final formState=formkey.currentState;
    if(formState.validate())
    {
      formState.save();
      try {
        key=name[0];
         AuthResult user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: email, password: password) ;
            await DatbaseSevice(uid: user.user.uid).updateUserData(number,itemSelected,city,user.user.uid,name,key,0,0);
          user.user.sendEmailVerification();
          Navigator.of(context).pop();
        print(user.user.email);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(User: user)));
      }catch(e){
        print(e.message);
      }
    }
  }

}