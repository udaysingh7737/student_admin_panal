import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_admin_panal/Home/home_page.dart';


class Login_Page extends StatefulWidget {
  const Login_Page({Key? key}) : super(key: key);



  @override
  _Login_PageState createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void showErrorAlert(dynamic title,dynamic content,dynamic action,dynamic route,dynamic buttonColor){
    showDialog(context: context, builder: (BuildContext context)=>
        CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            children: [
              Text(content,style:const TextStyle(fontSize: 25.0),),
            ],
          ),
          actions: [
            CupertinoDialogAction(child:Text(action,style: TextStyle(color: buttonColor),),
              onPressed: (){
                if(route == "homePage"){
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Student Admin Panel"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[

                   const Text("Login Page",style: TextStyle(fontSize: 35,fontStyle: FontStyle.italic),),

                  const SizedBox(height: 40.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0,right: 35.0,top: 25.0,bottom: 15.0),
                    child: Container( decoration: BoxDecoration(color: Colors.purple[200],
                        borderRadius: BorderRadius.circular(25)
                    ),
                      height: 60.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                        child: TextFormField(
                          controller: _emailController,

                          onChanged: (value){},
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email_rounded),
                            hintText: "Enter Admin Email Address",
                            border: InputBorder.none,

                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0,),

                  Padding(
                    padding: const EdgeInsets.only(left: 35.0,right: 35.0,top: 25.0,bottom: 15),
                    child: Container( decoration: BoxDecoration(color: Colors.purple[200],
                        borderRadius: BorderRadius.circular(25)
                    ),
                      height: 60.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0,top: 8,),
                        child: TextFormField(
                          controller: _passwordController,

                          onChanged: (value){},
                          decoration: const InputDecoration(
                            icon: Icon(Icons.vpn_key),
                            hintText: "Enter Your Password",
                            border: InputBorder.none,

                          ),

                          obscureText: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0,),


                  MaterialButton(child:const Text("Login",
                    style: TextStyle(fontSize: 25,
                      color: Colors.white
                    ),
                  ),
                      color: Colors.purple,
                      height: 60.0,minWidth: 200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)
                      ),
                      onPressed: ()async{
                        try {
                          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                          );
                          showErrorAlert(
                              "Login Successfully!!",
                              "WELCOME to Student Admin Portal",
                              "Go to Home Page",
                              "homePage",
                            Colors.green,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print("ser Not Fount Please Try Again!!");
                            showErrorAlert(
                                "Error to Login",
                                "User Not Fount Please Try Again!!",
                                "Try Again!!",
                                "tryAgain",
                                Colors.red,
                            );
                          } else if (e.code == 'wrong-password') {
                            showErrorAlert(
                                "Error to Login",
                                "Wrong password provided for that user.!!",
                                "Try Again!!",
                                "tryAgain",
                              Colors.red
                            );
                            print('Wrong password provided for that user.');
                          }
                        }

                  }),


                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}
