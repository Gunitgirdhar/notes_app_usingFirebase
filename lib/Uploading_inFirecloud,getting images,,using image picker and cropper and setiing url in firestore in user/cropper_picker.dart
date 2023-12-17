import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cli/Models/Notemodel.dart';
import 'package:firebase_cli/Models/UserModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCropperPicker extends StatefulWidget {
  const ImageCropperPicker({super.key});

  @override
  State<ImageCropperPicker> createState() => _ImageCropperPicker();
}

class _ImageCropperPicker extends State<ImageCropperPicker> {
  String url="";
  File? pickImagefile;
  List<String> mUrlList = [];
  late FirebaseStorage firebaseStorage;
  String imageUrl = " ";

  @override
  void initState() {
    super.initState();
    firebaseStorage = FirebaseStorage.instance;
    final storageRef = FirebaseStorage.instance.ref();
    getImgUrl(storageRef);
    // docs ke collections me se imgurl ka data le rhe hn
    FirebaseFirestore.instance.collection("users")
        .doc("SBqgBwAOqHVP7zslYTBNsWjAprB3"
    ).get().then((value) => {
      url=value.get("imgUrl")
    });
  }

  void getImgUrl(Reference ref) async {
    ListResult result = await ref.child("images").listAll();

    for (Reference item in result.items) {
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
      appBar: AppBar(title: Text("cropper and image picker"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150, width: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow,
                  image: pickImagefile != null ? DecorationImage(
                      image: FileImage(pickImagefile!), fit: BoxFit.cover
                  ) : DecorationImage(image: NetworkImage(url))
              ),
            ),
            ElevatedButton(onPressed: (){
              if(pickImagefile != null){
                var currTime=DateTime.now().microsecondsSinceEpoch;
                 var uploadref=firebaseStorage.ref().child("images/profilepic/img_$currTime");

                try{
                  uploadref.putFile(pickImagefile!).then((p0)  async{
                    //  updating the link in firestore
                  // step 1 downloading url
                    var downloadurl=await p0.ref.getDownloadURL();
                    // step 2 updating in firestore
                    FirebaseFirestore.instance.collection("users")
                        .doc("SBqgBwAOqHVP7zslYTBNsWjAprB3"
                    ).collection("profilepic").add({
                      "profile pidc  ": downloadurl,
                    }).then((value) => print("profile picture updates"));

                    FirebaseFirestore.instance.collection("users")
                        .doc("SBqgBwAOqHVP7zslYTBNsWjAprB3"
                    )
                    .update(UserModel(imgUrl: downloadurl).toJson() );
                    print("Current profile pic updated ");

                  });
                } catch(e){
                  print("error : ${e.toString()}");
                }
              }
            }, child: Text("Upload profile on forecloud")),
            Container(
                height: 200,
                width: double.infinity,
                child: StreamBuilder(
                stream:  FirebaseFirestore.instance.collection("users")
                .doc("SBqgBwAOqHVP7zslYTBNsWjAprB3").collection("profilepic").snapshots(),
                builder: (_,snapshot){
                  if(snapshot.hasData){
                    return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context, index) {
                      return Image.network(snapshot.data!.docs[index].data()["profile pidc"]);
                    },);
                  }

                  return Container();
                })
            )
          ]
            ),


        ),


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(context: context, builder: (context) {
            return Container(
                height: 70,

                decoration: BoxDecoration(
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    InkWell(
                    onTap: ()async{
                ///////////// image picking work here///////////////
                var imagefromGallery= await ImagePicker().pickImage(
                source: ImageSource.gallery);
            if (imagefromGallery != null) {
              //  pickImagefile  =File(imagefromGallery.path);
              // es part ko comment kr dua bcoz ab yeh path thodi na denge ab toh cropped image path denge
              var croppedFile = await ImageCropper().cropImage(
                sourcePath: imagefromGallery.path,
                uiSettings: [
                  AndroidUiSettings(
                      toolbarTitle: 'Cropper',
                      toolbarColor: Colors.deepOrange,
                      toolbarWidgetColor: Colors.white,
                      initAspectRatio: CropAspectRatioPreset.original,
                      lockAspectRatio: false),
                  IOSUiSettings(
                    title: 'Cropper',
                  ),
                  WebUiSettings(
                    context: context,
                    presentStyle: CropperPresentStyle.dialog,
                    boundary: const CroppieBoundary(
                      width: 520,
                      height: 520,
                    ),
                    viewPort:
                    const CroppieViewPort(
                        width: 480, height: 480, type: 'circle'),
                    enableExif: true,
                    enableZoom: true,
                    showZoomer: true,
                  ),
                ],
              );
              if (croppedFile != null) {
                pickImagefile = File(croppedFile.path,

                );
              }

              print(pickImagefile);
              setState(() {

              });
            }
          },
            child: Icon(Icons.photo,size: 30,)),
            InkWell(
            onTap: ()async{
            ///////////// image picking work here///////////////
            var imageFromCamera= await ImagePicker().pickImage(source: ImageSource.camera);
            if(imageFromCamera != null){
            //  pickImagefile  =File(imagefromGallery.path);
            // es part ko comment kr dua bcoz ab yeh path thodi na denge ab toh cropped image path denge
            var croppedFile= await ImageCropper().cropImage(sourcePath: imageFromCamera.path,
            uiSettings: [
            AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
            IOSUiSettings(
            title: 'Cropper',
            ),
            WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
            width: 520,
            height: 520,
            ),
            viewPort:
            const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
            ),
            ],
            );
            if(croppedFile != null){
            pickImagefile =File(croppedFile.path,

            );
            }

            print(pickImagefile);
            setState(() {

            });
            }
            },
            child: Icon(Icons.camera_alt_outlined,size: 30,))

            ],
            ),
            );
          },
          );
        },
      ),
    );
  }
}
