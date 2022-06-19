import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:thenewnews/dbHelper/mongodb.dart';

import '../model/MDBModel.dart';

class NewsCard extends StatelessWidget {
    final MongoDBModel data;
    final bool isPublisher;

    NewsCard({Key? key,required this.data,required this.isPublisher}) : super(key: key);

    TextEditingController titleET = TextEditingController();
    TextEditingController bodyET = TextEditingController();


  @override
  Widget build(BuildContext context) {
    titleET.text = data.title;
    bodyET.text = data.body;
      return Container(padding: EdgeInsets.all(10),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),border: Border.all(color: Colors.white,width: 1),color: Colors.orange[300]),margin: EdgeInsets.only(left:25,right: 25),
        child: Column(children: [
          Text(data.title,style: GoogleFonts.barlowCondensed(fontSize: 36)),
          SizedBox(height: 5,),
          Container(child: Image.memory(base64Decode(data.image))),
          SizedBox(height: 15,),
          SingleChildScrollView(
            child: Container(
              child: Column(children: [
                Center(
                child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0,left: 10.0,right: 10.0),
                child: ReadMoreText(
                  data.body,style: TextStyle(color: Colors.black,fontSize: 16),
                  trimLines: 2,
                  colorClickableText: Colors.black,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  lessStyle: TextStyle(color: Colors.black,fontSize: 12, fontWeight: FontWeight.bold),
                  moreStyle: TextStyle(color: Colors.black,fontSize: 12, fontWeight: FontWeight.bold),
                ),

                // Text(widget.description,style: TextStyle(color: Colors.black,fontSize: 16),),
              ),),


                isPublisher==true?IconButton(onPressed: () async {
                  ADUpdate(context);
                }, icon: Icon(Icons.edit,)):Container(),

                isPublisher==true?ElevatedButton(onPressed: () async {
                  await MongoDatabase.delete(data);
                }, child: Text("Remove")):Container(),
            ],),),
          ),


        ],),
      );

  }

    Future<void> _updateData(var _id, String publisher, body, String title, String image)async{
      final updateData = MongoDBModel(id: _id, publisher: publisher, title: title, image: image, body: body);
      await MongoDatabase.update(updateData).whenComplete(() {


      });

    }

    Future<void> ADUpdate(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Update'),
              content: Column(children: [
                TextFormField(controller: titleET,decoration: InputDecoration(),),
                TextFormField(controller: bodyET,),


              ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text('UPDATE'),
                  onPressed: () {
                    _updateData(data.id, data.publisher, bodyET.text, titleET.text, data.image);
                  },
                ),
              ],
            );
          });
    }
}
