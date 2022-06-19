import 'package:flutter/material.dart';
import 'package:thenewnews/dbHelper/mongodb.dart';
import 'package:thenewnews/model/MDBModel.dart';
import 'package:thenewnews/widgets/newsCard.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class NewsEditScreen extends StatefulWidget {
  const NewsEditScreen({Key? key}) : super(key: key);

  @override
  State<NewsEditScreen> createState() => _NewsEditScreenState();
}

class _NewsEditScreenState extends State<NewsEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder(
            future: MongoDatabase.getQueryDataByPublisher("publisher"),
            builder: (context,AsyncSnapshot snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){

                return Center(child: CircularProgressIndicator(),);
              }
              else{
                var totalData = snapshot.data.length;
                print(totalData);
                if(snapshot.hasData){

                  return ListView.builder(scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        return NewsCard(data: MongoDBModel.fromJson(snapshot.data[index]),isPublisher: true);
                      });
                }else{
                  return Center(child: Text("No data available"),);
                }
              }

            },
          ),
        ),
      ),
    );
  }


}
