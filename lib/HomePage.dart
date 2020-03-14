import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seva/Animations/FadeAnimation.dart';
import 'package:seva/root.dart';
import 'package:seva/sidebar/collapsing_navigation_drawer_widget.dart';
import 'package:sms/sms.dart';
import 'package:toast/toast.dart';

import 'auth.dart';
import 'auth_provider.dart';
QuerySnapshot snapshot;
class Home extends StatefulWidget
{

  const Home({Key key,@required this.User,this.onSignedOut}) : super(key: key);
  final  User;
  final VoidCallback onSignedOut;




  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Homestate();
  }}
 class Homestate extends State<Home>
 {
   final GlobalKey<FormState> formkey=GlobalKey<FormState>();
   String city,hospital;
   bool Aplus=false;
   bool Aminus=false;
   bool Bplus=false;
   bool Bminus=false;
   bool Oplus=false;
   bool Ominus=false;
   bool ABplus=false;
   bool ABminus=false;
   bool progressbar=false;
   DateTime currentBackPressTime;

   Future<void> _signOut(BuildContext context) async {
     try {
       final BaseAuth auth = AuthProvider.of(context).auth;
       await auth.signOut();
       widget.onSignedOut();
     } catch (e) {
       print(e);
     }
   }

   Widget checkbox(String title,bool boolvalue)
   {
     return Column(
       mainAxisAlignment:MainAxisAlignment.center,
       children: <Widget>[
         Text(title,style: TextStyle(color: Colors.white),),
     Theme(
     data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
     child:
         Checkbox(
           value: boolvalue,
         onChanged: (boolvalue){
           setState(() {
             switch(title)
             {
               case "A+":Aplus=boolvalue;
               break;
               case "A-":Aminus=boolvalue;
               break;
               case "B+":Bplus=boolvalue;
               break;
               case "B-":Bminus=boolvalue;
               break;
               case "O+":Oplus=boolvalue;
               break;
               case "O-":Ominus=boolvalue;
               break;
               case "AB+":ABplus=boolvalue;
               break;
               case "AB-":ABminus=boolvalue;
               break;

             }
           });
         },),
       ),

       ],
     );
   }

   Future<bool> onWillPop() async {
//     DateTime now = DateTime.now();
//     if (currentBackPressTime == null ||
//         now.difference(currentBackPressTime) > Duration(seconds: 3)) {
//       currentBackPressTime = now;
//       Toast.show("Press back again to exit" , context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.white,textColor: Colors.black);
//       return false;
//     }
//     return true;
     return showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           title: Text('Are you sure?'),
           content: Text('Do you want to exit an App'),
           actions: <Widget>[
             FlatButton(
               child: Text('No'),
               onPressed: () {
                 Navigator.of(context).pop(false);
               },
             ),
             FlatButton(
               child: Text('Yes'),
               onPressed: () {
                 exit(0);
               },
             )
           ],
         );
       },
     ) ?? false;
   }


   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Color.fromRGBO(3, 9, 23, 1),
       appBar: AppBar(
         backgroundColor: Colors.black,
         title: Text('SEVA'),
         actions: <Widget>[
           FlatButton(
             child: Text('Logout', style: TextStyle(fontSize: 17.0, color: Colors.white)),
             onPressed: () => _signOut(context),
           )
         ],
       ),

       body:WillPopScope(
         onWillPop: onWillPop,
         child:  Stack(
           children:<Widget>[
             progressbar==false ?
             Container(
               padding: EdgeInsets.only(left: 120,top: 30),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                   FadeAnimation(1.2, Text("Request",
                     style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),)),
                   SizedBox(height: 30,),
                   FadeAnimation(1.5, Container(
                     padding: EdgeInsets.all(10),
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.white
                     ),
                     child: Form(
                       key: formkey,
                       child:Column(
                         children: <Widget>[
                           Container(

                             width:230,
                             decoration: BoxDecoration(

                                 border: Border(bottom: BorderSide(color: Colors.grey[300]))
                             ),
                             child: TextFormField(
                               decoration: InputDecoration(
                                   border: InputBorder.none,
                                   hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                                   hintText: "Enter City Name"
                               ),
                               validator:(input) {
                                 if(input.isEmpty){
                                   return "Please enter city";
                                 }
                               },
                               onChanged: (input) => city=input.toLowerCase() ,
                             ),
                           ),
                           Container(
                             width: 230,
                             decoration: BoxDecoration(
                             ),
                             child: TextFormField(


                               decoration: InputDecoration(
                                   border: InputBorder.none,
                                   hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                                   hintText: "Enter Hospital Name"
                               ),
                               obscureText: false,
                               validator:(input) {
                                 if(input.isEmpty){
                                   return 'Please Enter Hospital Name';
                                 }
                               },
                               onChanged: (input) => hospital=input ,
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),),
                   SizedBox(height: 80,),
                   FadeAnimation(
                     1.8,

                     Container(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children:<Widget>[
                               checkbox("A+", Aplus),
                               checkbox("A-",Aminus),
                               checkbox("B+",Bplus),
                               checkbox("B-",Bminus),],),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children:<Widget>[
                               checkbox("O+",Oplus),
                               checkbox("O-",Ominus),
                               checkbox("AB+",ABplus),
                               checkbox("AB-",ABminus),
                             ],),


                         ],

                       ),
                     ),

                   ),

                   SizedBox(height: 50,),

                   FadeAnimation(1.8,

                       Container(
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(50),
                             color: Colors.blue[800]
                         ),
                         width: 190,
                         height: 50,

                         padding: EdgeInsets.all(8),
                         child: Center(child: FlatButton(child:Text("Send",style: TextStyle(color: Colors.white),),
                           onPressed: ()  {
                             getdata();
                           },

                         ),
                         ),




                       )

                   ),],
               ),
             ):Center(
               child: Container(
                   color: Color.fromRGBO(3, 9, 23, 1),
                   width: 70.0,
                   height: 70.0,
                   child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator()))),
             ),

             CollapsingNavigationDrawer(),
           ],
         ),
       )
     );
   }



  Future<void> getdata() async{
    final formState=formkey.currentState;
    if(formState.validate()) {
      formState.save();
      setState(() {
        progressbar=true;
      });
      if(Aplus==true)
      {
        snapshot=await Firestore.instance.collection('collection').where('Blood group',isEqualTo: 'A+').where('City',isEqualTo: city).
        getDocuments();
        for(int i=0;i<snapshot.documents.length;i++){
          send(snapshot.documents[i].data['Mobile number']);
          print(snapshot.documents[i].data['Mobile number']);
        }
        Toast.show("Message sent" , context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.white,textColor: Colors.black);
      }

      if(Aminus==true)
      {
        snapshot=await Firestore.instance.collection('collection').where('Blood group',isEqualTo: 'A-').where('City',isEqualTo: city).
        getDocuments();
        for(int i=0;i<snapshot.documents.length;i++){
          send(snapshot.documents[i].data['Mobile number']);
          print(snapshot.documents[i].data['Mobile number']);
        }
        Toast.show("Message sent" , context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.white,textColor: Colors.black);
      }

      if(Bplus==true)
      {
        snapshot=await Firestore.instance.collection('collection').where('Blood group',isEqualTo: 'B+').where('City',isEqualTo: city).
        getDocuments();
        for(int i=0;i<snapshot.documents.length;i++){
          send(snapshot.documents[i].data['Mobile number']);
          print(snapshot.documents[i].data['Mobile number']);
        }
        Toast.show("Message sent" , context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.white,textColor: Colors.black);
      }

      if(Bminus==true)
      {
        snapshot=await Firestore.instance.collection('collection').where('Blood group',isEqualTo: 'B-').where('City',isEqualTo: city).
        getDocuments();
        for(int i=0;i<snapshot.documents.length;i++){
          send(snapshot.documents[i].data['Mobile number']);
          print(snapshot.documents[i].data['Mobile number']);
        }
        Toast.show("Message sent" , context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.white,textColor: Colors.black);
      }

      if(Oplus==true)
      {
        snapshot=await Firestore.instance.collection('collection').where('Blood group',isEqualTo: 'O+').where('City',isEqualTo: city).
        getDocuments();
        for(int i=0;i<snapshot.documents.length;i++){
          send(snapshot.documents[i].data['Mobile number']);
          print(snapshot.documents[i].data['Mobile number']);
        }
        Toast.show("Message sent" , context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.white,textColor: Colors.black);
      }

      if(Ominus==true)
      {
        snapshot=await Firestore.instance.collection('collection').where('Blood group',isEqualTo: 'O-').where('City',isEqualTo: city).
        getDocuments();
        for(int i=0;i<snapshot.documents.length;i++){
          send(snapshot.documents[i].data['Mobile number']);
          print(snapshot.documents[i].data['Mobile number']);
        }
        Toast.show("Message sent" , context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.white,textColor: Colors.black);
      }

      if(ABplus==true)
      {
        snapshot=await Firestore.instance.collection('collection').where('Blood group',isEqualTo: 'AB+').where('City',isEqualTo: city).
        getDocuments();
        for(int i=0;i<snapshot.documents.length;i++){
          send(snapshot.documents[i].data['Mobile number']);
          print(snapshot.documents[i].data['Mobile number']);
        }
        Toast.show("Message sent" , context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.white,textColor: Colors.black);
      }

      if(ABminus==true)
      {
        snapshot=await Firestore.instance.collection('collection').where('Blood group',isEqualTo: 'AB-').where('City',isEqualTo: city).
        getDocuments();
        for(int i=0;i<snapshot.documents.length;i++){
          send(snapshot.documents[i].data['Mobile number']);
          print(snapshot.documents[i].data['Mobile number']);
        }
        Toast.show("Message sent" , context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.white,textColor: Colors.black);
      }
      setState(() {
        progressbar=false;
      });
    }

  }
   void send(String number){
     String num=number;
     String msg="There is an emergency of your blood group.Your donation can save a person's life.For donation come to hospital\nHospital Name:"+hospital ;
     SmsSender sender=SmsSender();
     SmsMessage message=new SmsMessage(num, msg);
     message.onStateChanged.listen((state){
       if(state==SmsMessageState.Sent){
         print('sms sent');
       }
       else{
         print('failed');
       }
     });
     sender.sendSms(message);

   }



 }
