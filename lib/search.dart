import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seva/searchbyservice.dart';
import 'package:seva/userdetails.dart';

import 'HomePage.dart';


class search extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return searchstate();
  }

}
class searchstate extends State<search>
{
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text('SEARCH'),
          backgroundColor: Color.fromRGBO(3, 9, 23, 1),

        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 10.0),
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(context,element);
              }).toList())
        ]));
  }
}

Widget buildResultCard(BuildContext ctx,data) {

   return MaterialButton(
     onPressed: (){
       final snackbar=SnackBar(content: Text("tap"));
       Navigator.push(ctx, MaterialPageRoute(builder: (context)=>userdetails(map: data)));
     },
     child: Card(
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
       elevation: 2.0,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[

              Icon(
               Icons.account_circle,
                color: Colors.black,
                size: 45.0,
             ),
           SizedBox(height: 5,),
           Center(
               child: Text(data['name'],
                 textAlign: TextAlign.center,
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 20.0,
                 ),
               )
           ),
         ],


       ),

     ),
   );
}