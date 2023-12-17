import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageGettingPage extends StatefulWidget {
  const ImageGettingPage({super.key});

  @override
  State<ImageGettingPage> createState() => _ImageGettingPageState();
}

class _ImageGettingPageState extends State<ImageGettingPage> {
  List<String> mUrlList=[];
  late FirebaseStorage firebaseStorage;
  String imageUrl=" ";

  @override
  void initState() {
    super.initState();
   firebaseStorage = FirebaseStorage.instance;
    final storageRef = FirebaseStorage.instance.ref();
    getImgUrl(storageRef);
  }

  void getImgUrl(Reference ref)async{


    ListResult result =await ref.child("images").listAll();

    for(Reference item in result.items){
      imageUrl = await item.getDownloadURL();
      mUrlList.add(imageUrl);
    }
    setState(() {

    });

    /* imageUrl =
        await ref.child("images/android1.png").getDownloadURL();
    setState(() {

    });*/
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Getting images from firecloud"),
      ),
      body: /*Column(
        children: [
          Image.network(imageUrl),
        ],
      ),*/
      ListView.builder(
        itemCount: mUrlList.length,
        itemBuilder: (context, index) {
        return Image.network(mUrlList[index]);
      },)
    );
  }
}
