import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('student');

  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('student').snapshots();
  FirebaseAuth auth = FirebaseAuth.instance;


  final _random = Random();
  dynamic height;
  final TextEditingController studentName = TextEditingController();
  final TextEditingController studentClass = TextEditingController();

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    final dynamic userEmail = auth.currentUser!.email;
    print(userEmail);
    super.setState(fn);
  }

  void showAlert(){
    showDialog(context: context, builder: (BuildContext context)=>
    CupertinoAlertDialog(
      title:const Text("Add Student"),
      content: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(height: 45.0,
              child: CupertinoTextField(placeholder: "Student Name",
                controller: studentName,
                onChanged: (value){},

              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(height: 45.0,
              child: CupertinoTextField(
                placeholder: "Student Class",
                controller: studentClass,
                onChanged: (value){},

              ),
            ),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(child:const Text("Add"),
        onPressed: (){
          collectionReference.add(
              {"name": studentName.text,"class": studentClass.text})
              .then((value) => Navigator.pop(context));
        },)
      ],
      
       
      
    )
    );
  }

  void showErrorAlert(dynamic title,dynamic content,dynamic action,dynamic route){
    showDialog(context: context, builder: (BuildContext context)=>
        CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            children: [
              Text(content,style:const TextStyle(fontSize: 25.0),),
            ],
          ),
          actions: [
            CupertinoDialogAction(child:Text(action),
              onPressed: (){
              if(route == "home"){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomePage()));
              }else if(route == "tryAgain"){
                Navigator.pop(context);
              }

              },)
          ],



        )
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    height = 70.0;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(child:const Icon(Icons.add),
        onPressed: (){
          showAlert();
        },
      ),
      // ignore: file_names
      appBar: AppBar(
        title: const Text("Student Admin Panel"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  "Total Students Listing",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),

              Padding(
                padding: const EdgeInsets.only(
                    right: 25.0, bottom: 500.0, left: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade500,
                          spreadRadius: 0.0,
                          blurRadius: 10,
                          offset: const Offset(3.0, 3.0)),
                      BoxShadow(
                          color: Colors.grey.shade500,
                          spreadRadius: 0.0,
                          blurRadius: 10 / 2.0,
                          offset: const Offset(3.0, 3.0)),
                      const BoxShadow(
                          color: Colors.white,
                          spreadRadius: 2.0,
                          blurRadius: 10,
                          offset: Offset(-3.0, -3.0)),
                      const BoxShadow(
                          color: Colors.white,
                          spreadRadius: 2.0,
                          blurRadius: 10 / 2,
                          offset: Offset(-3.0, -3.0)),
                    ],
                  ),
                  height: size.height * 0.70,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CupertinoActivityIndicator(
                            radius: 60,
                          ),
                        );
                      }

                      return ListView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,left: 20.0,right: 20.0),
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 4),
                              height: height,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.primaries[_random.nextInt(Colors.primaries.length)]
                                  [_random.nextInt(9) * 100],),
                              child:data != null ? ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      const Text("Name: ",
                                        style:TextStyle(fontSize: 20),),
                                      Text(data['name'],
                                        style:const TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                ),
                                subtitle:  Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      const Text("Class: ",
                                        style: TextStyle(fontSize: 16),),
                                      Text( data['class'],style:const TextStyle(fontSize: 16),),
                                    ],
                                  ),
                                ),
                              ) :const Text("No Record to Show Add Studnet"),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  // ignore: avoid_unnecessary_containers
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
