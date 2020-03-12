import 'package:cloud_firestore/cloud_firestore.dart';
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

       body:Stack(
         children:<Widget>[

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
                           onChanged: (input) => city=input ,
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
                ),
           CollapsingNavigationDrawer(),
               ],
             ),
     );
   }



  Future<void> getdata() async{
  if(Oplus==true)
    {
      snapshot=await Firestore.instance.collection('collection').where('Blood group',isEqualTo: 'O+').getDocuments();
         for(int i=0;i<snapshot.documents.length;i++){
           send(snapshot.documents[i].data['Mobile number']);
           print(snapshot.documents[i].data['Mobile number']);
         }
           


      Toast.show("Message sent to O+" , context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.white,textColor: Colors.black);
    }
  }
   void send(String number){
     String num=number;
     String msg="Message from SEVA";
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
     Toast.show("Message sent to "+num, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.white,textColor: Colors.black);
   }



 }
