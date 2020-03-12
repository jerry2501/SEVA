import 'package:cloud_firestore/cloud_firestore.dart';
class DatbaseSevice{
    final String uid;
    DatbaseSevice({this.uid});
  final CollectionReference collectionReference=Firestore.instance.collection('collection');

  Future updateUserData(String number,var itemselected,String city,String uid,String name,String key,int count,int credit) async
  {
    return await collectionReference.document(uid).setData({
      'Mobile number':number,
      'Blood group':itemselected,
      'City':city,
      'Uid':uid,
      'name':name,
      'searchKey':key,
      'Donate count':count,
      'Credit':credit,
    });
  }
}