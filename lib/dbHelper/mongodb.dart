import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:thenewnews/dbHelper/constant.dart';
import 'package:thenewnews/model/MDBModel.dart';

class MongoDatabase{
  static var db , userCollection;
  static connect() async{
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
    
  }

  static Future<List<Map<String, dynamic>>>getQueryData() async{
    final data = await userCollection.find().toList();
    return data;
  }


  static Future<List<Map<String, dynamic>>>getQueryDataByPublisher(String publisherName) async{
    final data = await userCollection.find(where.eq("publisher",publisherName)).toList();
    return data;
  }

  static Future<void> update(MongoDBModel data) async{
    var result = await userCollection.findOne({
      "_id":data.id
    });
    result['title']=data.title;
    result['body']=data.body;
    result['image']=data.image;

    var response = await userCollection.save(result);
    inspect(response);

  }

  static Future<Map<String, dynamic>>getData() async {
      final arrData = await userCollection.find().toList();
      return arrData;

  }

  static delete(MongoDBModel user ) async{
    await userCollection.remove(where.id(user.id));
  }

  static Future<String> insert(MongoDBModel data)async{
    try{
      var result = await userCollection.insertOne(data.toJson());
      if(result.isSuccess){
        return "Data Inserted";
      }else{
        return "Something wrong while inserting data";
      }
  }catch(e) {
     print(e.toString());
     return e.toString();
    }
  }
}