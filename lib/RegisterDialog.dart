
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safor/services/model.dart';
import 'package:safor/services/services.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterDialog extends AlertDialog{

  final AuthService _authService = AuthService();

  final username = TextEditingController();
  final useremail = TextEditingController();
  final password = TextEditingController();

  Widget buildDialog(BuildContext context, State state, User? user){
    return ScopedModelDescendant<AppModel>(
        builder: (context,child,model) {
      return ListTile(
        title: Text('Register'),
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
                        height: 300,
                        width: 400,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: useremail,
                              decoration:
                              InputDecoration(labelText: 'Email'),
                            ),
                            TextFormField(
                              controller: username,
                              decoration:
                              InputDecoration(labelText: 'Name'),
                            ),
                            TextFormField(
                              controller: password,
                              obscureText: true,
                              decoration:
                              InputDecoration(labelText: 'Password',),
                            ),

                            ElevatedButton(
                                child: Text('Register'),
                                onPressed: () async {
                                  if (await model.registerModelFunc(useremail.text, password.text, username.text)){
                                    print("Register successful");
                                    Navigator.pop(context);
                                  }else{
                                    print("Error registering");
                                  }

                                })
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