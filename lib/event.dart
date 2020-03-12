import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Animations/FadeAnimation.dart';

class event extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return eventstate();
  }

}
class eventstate extends State<event>
{
  String hospital_name,city,description,date;
  DateFormat _dateFormat=new DateFormat.yMMMMd();
  DateTime _date;
  final GlobalKey<FormState> formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimation(1.2, Text("Create an Event",
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
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]))
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                            hintText: "Enter the Hospital Name"
                        ),
                        validator:(input) {
                          if(input.isEmpty){
                            return "Please type Hospital name";
                          }
                        },
                        onChanged: (input) => hospital_name=input ,
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
                            hintText: "Enter the City"
                        ),

                        validator:(input) {
                          if(input.isEmpty){
                            return 'Please type City name';
                          }
                        },
                        onChanged: (input) => city=input ,
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
                            hintText: "Enter some Description"
                        ),

                        validator:(input) {
                          if(input.isEmpty){
                            return 'Please type some Description';
                          }
                        },
                        onChanged: (input) => description=input ,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(_date==null?'Nothing is selected':_dateFormat.format(_date).toString()),
                       IconButton(icon:Icon(Icons.calendar_today) , onPressed:() {
                         Future<DateTime> selectedDate=showDatePicker(context: context, initialDate: DateTime.now(),
                             firstDate: DateTime(2019), lastDate: DateTime(2030),
                         builder: (BuildContext context,Widget child){
                           return Theme(
                             data: ThemeData.dark(),
                             child: child,
                           );
                         }
                         ).then((eventdate){
                           setState(() {
                             _date=eventdate;
                             date=_dateFormat.format(_date).toString();
                           });
                         });
                       })
                      ],
                    )
                  ],
                ),
              ),
            )),
            SizedBox(height: 40,),
            FadeAnimation(1.8, Center(
              child: Container(
                width: 130,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue[800]
                ),
                child: Center(child: FlatButton(child:Text("Create", style: TextStyle(color: Colors.white.withOpacity(.7)),),
                  onPressed: (){
                  createevent();
                  },

                )),
              ),
            )),

          ],
        ),
      ),
    );

  }
  Future<void> createevent() async
  {
    final formState=formkey.currentState;
    if(formState.validate()) {
      formState.save();
      Firestore.instance.collection('events').document().setData({
        'Hospital name': hospital_name,
        'City': city,
        'Description': description,
        'Date': date,
      });
    }
  }
  }

