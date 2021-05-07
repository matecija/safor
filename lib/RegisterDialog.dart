
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safor/services/services.dart';

class RegisterDialog extends AlertDialog{

  final AuthService _authService = AuthService();

  final username = TextEditingController();
  final useremail = TextEditingController();
  final password = TextEditingController();

  Widget buildDialog(BuildContext context, State state, User? user){
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
                            InputDecoration(labelText: 'Password', ),
                          ),

                          ElevatedButton(
                              child: Text('Login'),
                              onPressed: () async {
                                User result = await _authService.register(email: useremail.text, password: password.text, name: username.text);
                                if(result == null){
                                  print("Error registering user");
                                }else{
                                  print("Registration complete, signed in as");
                                  state.setState((){
                                    user = result;
                                    print(result);
                                  });

                                  Navigator.pop(context);
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
}