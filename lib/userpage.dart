/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Models/UserModel.dart';


class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late FirebaseFirestore db;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var ageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
      ),
      body: StreamBuilder(
       // stream:db.collection("notes").snapshots(),
       stream: db.collection("users").where('name', isGreaterThanOrEqualTo: "Rami")
            .where('name', isLessThanOrEqualTo: "Rami"+ '\uf8ff').snapshots(),

        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
          } else if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  var model =
                  UserModel.fromJson(snapshot.data!.docs[index].data());
                  model.id = snapshot.data!.docs[index].id;
                  print("id: ${model.id}");
                  return ListTile(
                    title: Text('${model.name}'),
                    subtitle: Text('${model.age}'),
                    trailing: InkWell(
                        onTap: () {
                          //delete
                          db
                              .collection("users")
                              .doc(model.id)
                              .delete()
                              .then((value) => print("${model.id} deleted"));
                        },
                        child: Icon(Icons.delete)),
                  );
                });
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (_) {
                print(MediaQuery.of(context).viewInsets.bottom);
                return Container(
                  height: MediaQuery.of(context).viewInsets.bottom == 0.0
                      ? 600
                      : 1200,
                  color: Colors.blue.shade100,
                  child: Column(
                    children: [
                      Text('Add User'),
                      TextField(
                        controller: nameController,
                        onTap: () {},
                        decoration: InputDecoration(
                            label: Text('Name'),
                            hintText: "Enter Name here..",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21))),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            label: Text('Email'),
                            hintText: "Enter Email here..",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21))),
                      ),
                      TextField(
                        controller: ageController,
                        onTap: () {},
                        decoration: InputDecoration(
                            label: Text('Age'),
                            hintText: "Enter Age here..",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21))),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            db
                                .collection("users")
                                .add(UserModel(
                                name: nameController.text.toString(),
                                email: emailController.text.toString(),
                                age: int.parse(ageController.text.toString()))
                                .toJson())
                                .then((value) {
                              print(value.id);
                            });
                          },
                          child: Text('Submit'))
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
*/
