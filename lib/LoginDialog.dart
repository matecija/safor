
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safor/services/model.dart';
import 'package:safor/services/services.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginDialog extends AlertDialog{

  final useremail = TextEditingController();
  final password = TextEditingController();

  Widget buildDialog(BuildContext context, State state , User? user){
    return ScopedModelDescendant<AppModel>(
      builder: (context,child,model){
        return  ListTile(
          title: Text('Login'),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    content: StatefulBuilder(
                      builder: (context, StateSetter setState) {
                        return Container(
                          height: 200,
                          width: 400,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: useremail,
                                decoration:
                                InputDecoration(labelText: 'Email'),
                              ),
                              TextFormField(
                                controller: password,
                                obscureText: true,
                                decoration:
                                InputDecoration(labelText: 'Password', ),
                              ),

                              ElevatedButton(
                                  child: Text('Login'),
                                  onPressed: () async {
                                    if( await model.loginModelFunc(useremail.text, password.text)){
                                      print("Logged in");
                                      Navigator.pop(context);
                                    }else{
                                      print("Error");
                                    }
                                  }
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                });
          },
        );
      }
    );



  }
}