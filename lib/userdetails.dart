import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seva/search.dart';
import 'package:toast/toast.dart';

class userdetails extends StatefulWidget
{
  var map=<dynamic,dynamic>{};


   userdetails({Key key, this.map}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return userstate();
  }

}
class userstate extends State<userdetails>
{
  int counter,credit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      counter=widget.map['Donate count'];
      credit=widget.map['Credit'];
    });

    print(widget.map['Blood group']);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Icon(
               Icons.account_circle,
               color: Colors.white,
               size: 100.0,
             ),
             SizedBox(height: 10,),
            Container(
                child:Text(widget.map['name'].toString(),style: TextStyle(fontSize: 30,color: Colors.white),textAlign: TextAlign.center,)
            ),
            SizedBox(height: 5,),
            Divider(
              color: Colors.white,
            ),
            SizedBox(height: 15,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                  Icon(
                    Icons.contact_phone,
                    color: Colors.white,
                    size: 30.0,
                  ),
                SizedBox(width: 15,),
                Container(
                    child:Text(widget.map['Mobile number'].toString(),style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,)
                ),
              ],
            ),
            SizedBox(height: 15,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.details,
                  color: Colors.white,
                  size: 30.0,
                ),
                SizedBox(width: 15,),
                Container(
                    child:Text(widget.map['Blood group'].toString(),style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,)
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    child:Text("Counts:",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,)
                ),
                FlatButton(
                  child: Text("-",style: TextStyle(fontSize: 20,color: Colors.white),),
                   onPressed: (){
                    setState(() {
                      if(counter>0){
                        counter=counter-1;
                        widget.map['Donate count']=counter;
                      }

                    });

                   },
                ),
                Text(counter.toString(),style: TextStyle(fontSize: 20,color: Colors.white)),
                FlatButton(
                  child: Text("+",style: TextStyle(fontSize: 20,color: Colors.white),),
                  onPressed: (){
                    setState(() {
                      counter=counter+1;
                      widget.map['Donate count']=counter;
                    });
                  },
                ),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    child:Text("Credits:",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,)
                ),
                FlatButton(
                  child: Text("-",style: TextStyle(fontSize: 20,color: Colors.white),),
                  onPressed: (){
                    setState(() {
                      if(credit>0){
                        credit=credit-10;
                        widget.map['Credit']=credit;
                      }

                    });

                  },
                ),
                Text(credit.toString(),style: TextStyle(fontSize: 20,color: Colors.white)),
                FlatButton(
                  child: Text("+",style: TextStyle(fontSize: 20,color: Colors.white),),
                  onPressed: (){
                    setState(() {
                      credit=credit+10;
                      widget.map['Credit']=credit;
                    });
                  },
                ),
              ],
            ),

          ],
        ),
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: () {
          Firestore.instance.collection('collection').document(widget.map['Uid']).updateData({
            'Donate count':counter,
            'Credit':credit,
          });
          Toast.show("Data Updated!!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.white,textColor: Colors.black);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>search()));
          },
        label: Text('DONE'),
        backgroundColor: Colors.blue,
      ),
    );

  }

}