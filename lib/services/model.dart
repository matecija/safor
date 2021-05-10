import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:safor/constants.dart';
import 'package:safor/services/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
class AppModel extends Model{

  User? currentUser;
  final AuthService _authService = AuthService();
  final FirestoreService _firestore = FirestoreService();


  Future<bool> loginModelFunc(String email, String passwd) async {
    try{
      User result = await _authService.signIn(email: email, password:passwd);
      if(result == null){
        print("Error loging in");

      }else{
        currentUser = result;
        print(currentUser);
        notifyListeners();
       return true;
      }

    }catch(e) {
      print(e);
    }
    return false;
  }



  Future<bool> reservarModelFunc(DateTime day, DateTime start, DateTime end, String desc, List<Event> retrievedData ) async{
    try {

      if(desc.isEmpty) {
        Fluttertoast.showToast(
            msg: "Description missing!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0
        );
      } else if(start.isAfter(end)){
        Fluttertoast.showToast(
            msg: "Error, start time is after end time",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0
        );
      }else{

        for(Event e in retrievedData){
          if(e.day == day &&

          )
        }


        _firestore.addReserva(
            day, start, end,currentUser!.displayName!,
            desc);
        print("Reserva añadida con exito.");
        notifyListeners();

        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }


  Future<bool> registerModelFunc(String email, String passwd, String name) async{
    try{
      User result = await _authService.register(email: email, password: passwd, name: name);
      if(result == null){
        print("Error registering user");
      }else {
        print("Registration complete, signed in as");
        currentUser = result;
        print(currentUser);
        notifyListeners();

        return true;
      }
    }catch(e){
      print(e.toString());
    }
    return false;
  }

  Future<bool> logoutModelFunc()async {
    try{
      currentUser = null;
      print("Log out complete");
      notifyListeners();
      return true;
    }catch(e){
      print(e.toString());
    }
    return false;
  }

}