import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cli/Firecloud/GettingImages_From_fireclous.dart';
import 'package:firebase_cli/Models/Notemodel.dart';
import 'package:firebase_cli/Authentication_Email/login_page.dart';
import 'package:firebase_cli/Authentication_Email/signUp_page.dart';
import 'package:firebase_cli/PhoneAuth/Login_phone.dart';
import 'package:firebase_cli/userpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Uploading_inFirecloud,getting images,,using image picker and cropper and setiing url in firestore in user/cropper_picker.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:LoginScreenPage(),
    );
  }
}

class HomePage extends StatefulWidget {
 String id;

 HomePage({required this.id});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var titleController=TextEditingController();
  var BodyController=TextEditingController();
  late FirebaseFirestore db;

  @override
  void initState() {
    super.initState();
    db=FirebaseFirestore.instance;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Notes"),),
      body: StreamBuilder(
        stream:  db.collection("users").doc(widget.id).collection("notes").snapshots(),
        //here we are applying the conditoin to filter the data yaha pr jinka naam ram se hn sirf vai aaenge aur bhi conditons lga skte hn hum
        /*db.collection("notes").where('title', isGreaterThanOrEqualTo: "Ram")
            .where('title', isLessThanOrEqualTo: "Ram"+ '\uf8ff').snapshots(),*/


        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasError){
            return Center(child: Text("${snapshot.error}"),);
          }
          else if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // es model me humne sara date ,from json krke get krlia aur ab usme id aur titile aur body teeno aa gaehn
                var model=NoteModel.fromJson(snapshot.data!.docs[index].data());
                return InkWell(
                  onTap: (){
                    ////////////////Updtaing///////////////////
                    showModalBottomSheet(context: context, builder: (context) {
                      titleController.text=model.title!;
                      BodyController.text=model.body!;
                      print(MediaQuery.of(context).viewInsets.bottom );
                      return Container(
                        padding: EdgeInsets.all(6),
                        color: Colors.blue.shade200,
                        height: MediaQuery.of(context).viewInsets.bottom== 0.0 ? 400 : 800,
                        child: Column(
                          children: [
                            TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                  hintText: "Enter title here",
                                  labelText: "Title",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide(color: Colors.white12)
                                  )
                              ),
                            ),
                            SizedBox(height: 10,),
                            TextField(
                              controller: BodyController,
                              decoration: InputDecoration(
                                  hintText: "Enter Body here",
                                  labelText: "Body",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide(color: Colors.white12)
                                  )
                              ),
                            ),
                            ElevatedButton(onPressed: (){
                              db.collection("notes").doc(snapshot.data!.docs[index].id).update((NoteModel(title: titleController.text.toString(),
                                  body: BodyController.text.toString()).toJson()))
                                  .then((value){

                                titleController.clear();
                                BodyController.clear();
                                Navigator.pop(context);
                              });
                            } , child: Text("Update"))
                          ],
                        )
                        ,);
                    },);
                  },
                  child: ListTile(
                    title: Text("${model.title.toString()}"),
                    subtitle:  Text("${model.body}"),
                    trailing: InkWell(
                        onTap: (){
                          db.collection("users").doc(widget.id).collection("notes").doc(snapshot.data!.docs[index].id).delete();
                          titleController.clear();
                          BodyController.clear();
                        },
                        child: Icon(Icons.delete)),
                  ),
                );
              },);
          }
          return Container();
        },),
      floatingActionButton: FloatingActionButton(onPressed: (){
        showModalBottomSheet(context: context, builder: (context) {
          print(MediaQuery.of(context).viewInsets.bottom );
          return Container(
            padding: EdgeInsets.all(6),
            color: Colors.blue.shade200,
            height: MediaQuery.of(context).viewInsets.bottom== 0.0 ? 400 : 800,
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter title here",
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.white12)
                  )
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: BodyController,
                decoration: InputDecoration(
                    hintText: "Enter Body here",
                    labelText: "Body",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: Colors.white12)
                    )
                ),
              ),
             ElevatedButton(onPressed: (){
               db.collection("users").doc(widget.id).collection("notes").add(NoteModel(title: titleController.text.toString(),
                   body: BodyController.text.toString()).toJson()).then((value){
                 print(value.id);
                 titleController.clear();
                 BodyController.clear();
                 Navigator.pop(context);
               });
             } , child: Text("Save"))
            ],
          )
            ,);
        },);


      },child: Icon(Icons.add)),
    );
  }
}
/////stream builder k jagah pehle future builder ka use kia tha toh yeh voh hn
/*
FutureBuilder(
future: db.collection("notes").get(),
builder: (context, snapshot) {
if(snapshot.connectionState==ConnectionState.waiting){
return Center(child: CircularProgressIndicator());
}
else if(snapshot.hasError){
return Center(child: Text("${snapshot.error}"),);
}
else if(snapshot.hasData){
return ListView.builder(
itemCount: snapshot.data!.docs.length,
itemBuilder: (context, index) {
var model=NoteModel.fromJson(snapshot.data!.docs[index].data());
return ListTile(
title: Text("${model.title}"),
subtitle:  Text("${model.body}"),
);
},);
}
return Container();
},)

*/
