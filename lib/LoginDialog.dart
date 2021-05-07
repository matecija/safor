
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safor/services/services.dart';

class LoginDialog extends AlertDialog{

  final AuthService _authService = AuthService();

  final useremail = TextEditingController();
  final password = TextEditingController();

  Widget buildDialog(BuildContext context, State state , User? user){
    return ListTile(
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
                                try{
                                  User result = await _authService.signIn(email: useremail.text, password: password.text);
                                  if(result == null){
                                    print("Error loging in");
                                  }else{
                                    state.setState((){
                                      user = result;
                                      print(user);
                                    });
                                    Navigator.pop(context);
                                  }

                                }catch(e) {
                                  print(e);
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
}