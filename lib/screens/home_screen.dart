import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lining_drawer/lining_drawer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:thenewnews/dbHelper/constant.dart';
import 'package:thenewnews/dbHelper/mongodb.dart';
import 'package:thenewnews/model/MDBModel.dart';
import 'package:thenewnews/screens/news_edit_screen.dart';
import 'package:thenewnews/widgets/newsCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final LiningDrawerController _controller = LiningDrawerController();

  TextEditingController titleET = TextEditingController();
  TextEditingController bodyET = TextEditingController();
  FilePickerResult? pickedFile;
  Uint8List? logoBase64;
  bool? imageselected=false;
  var imageEncoded;
  @override
  Widget build(BuildContext context) {
    return LiningDrawer(
      direction: DrawerDirection.fromLeftToRight,
      openDuration: const Duration(milliseconds: 250),
      controller: _controller,
      style: const LiningDrawerStyle(
        bottomColor: Colors.blue,
        middleColor: Colors.black,
        mainColor: Colors.white,
        bottomOpenRatio: 1.0,
        middleOpenRatio: 0.90,
        mainOpenratio: 0.82,
      ),
      drawer:  SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "New News",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _controller.toggleDrawer();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black26,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 5,),
            Align(alignment: Alignment.centerLeft,
              child: Container(width: 200,
                child: ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.black),onPressed: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: NewsEditScreen()));

                }, child: Text("My News",style: TextStyle(color: Colors.white),)),
              ),
            )
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
         leading: IconButton(
           onPressed: () {
           _controller.toggleDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: FutureBuilder(
              future: MongoDatabase.getQueryData(),
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
                        return NewsCard(data: MongoDBModel.fromJson(snapshot.data[index]),isPublisher: false);
                    });
                  }else{
                    return Center(child: Text("No data available"),);
                  }
                }

              },
            ),
          ),
        ),
        bottomSheet: SolidBottomSheet(
          headerBar: Container(
            color: Theme.of(context).primaryColor,
            height: 50,
            child: Center(
              child: Text("Add News"),
            ),
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(children: [
                Container(width:100,child: TextFormField(controller: titleET,)),
                logoBase64==null?ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.orange[800]), onPressed: (){
                  // print("LOGOBASE: "+logoBase64.toString());
                  chooseImage();

                }, child: Text("Choose Image")):logoBase64!=null?Container(width: 200,height: 200,child: Image.memory(logoBase64!)):Container(),
                Container(width:100,child: TextFormField(controller: bodyET,)),
                ElevatedButton(onPressed: (){
                  _insertData("publisher", bodyET.text, titleET.text, imageEncoded); //add data
                }, child: Text("ADD")),
              ],),
            ),
          ),
        ),
      ),
    );
  }

  chooseImage() async {
    pickedFile = await FilePicker.platform.pickFiles(allowMultiple: false,withData: true,type: FileType.image);
    if (pickedFile != null) {
      print(pickedFile);
      try {
        setState(() {
          logoBase64 = pickedFile!.files.first.bytes;
          imageEncoded = base64.encode(logoBase64!); // returns base64 string
          imageselected=true;
        });
      } catch (err) {
        // print(err);
      }
    } else {
      // print('No Image Selected');
    }
  }


  Future<void> _insertData(String publisher, body, String title, String image)async{
    var id = M.ObjectId();//unique key
    final data = MongoDBModel(publisher: publisher, title: title, image: image, body: body, id: id);
    var result = await MongoDatabase.insert(data); // ADD DATA
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added")));
  }

}
