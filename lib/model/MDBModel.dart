// To parse this JSON data, do
//
//     final mongoDbModel = mongoDbModelFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

import 'package:mongo_dart/mongo_dart.dart';

MongoDBModel mongoDbModelFromJson(String str) => MongoDBModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDBModel data) => json.encode(data.toJson());

class MongoDBModel {
  MongoDBModel({
   required this.id,
   required this.publisher,
   required this.title,
   required this.image,
   required this.body,
  });

  ObjectId id;
  String publisher;
  String title;
  String image;
  String body;

  factory MongoDBModel.fromJson(Map<String, dynamic> json) => MongoDBModel(
    id: json["_id"],
    publisher: json["publisher"],
    title: json["title"],
    image: json["image"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "publisher": publisher,
    "title": title,
    "image": image,
    "body": body,
  };
}
