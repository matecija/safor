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

        Fluttertoast.showToast(
            msg: "Credenciales incorrectas.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0
        );

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
            msg: "Falta descripción de la reserva.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0
        );
      } else if(start.isAfter(end)){
        Fluttertoast.showToast(
            msg: "Error, la reserva comienza después del tiempo de finalización.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0
        );
      }else{

        // If start or end time given is inside the range of any other event form same day
        for(Event e in retrievedData) {
          if (e.day == day && (
              (start.hour >= e.start.hour && start.hour <= e.end.hour) ||
              (end.hour >= e.start.hour && end.hour <= e.end.hour))) {
            Fluttertoast.showToast(
                msg: "Error, la reserva se sobrepone a una existente",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                fontSize: 16.0
            );

            return false;
          }
        }

          _firestore.addReserva(
              day, start, end,currentUser!.displayName!,
              desc);

          Fluttertoast.showToast(
              msg: "Reserva añadida con éxtio",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              fontSize: 16.0
          );
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
        Fluttertoast.showToast(
            msg: "Error registrando usuario!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0
        );
      }else {
        Fluttertoast.showToast(
            msg: "Registro completado.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0
        );
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

      notifyListeners();
      return true;
    }catch(e){
      print(e.toString());
    }
    return false;
  }

  List<Event> misreservas(List<Event> retrievedData ) {
    List<Event> myeventlist=[];

    try{
      for(Event e in retrievedData){
        if(e.name == currentUser!.displayName){
          myeventlist.add(e);
        }
      }
    }catch(e){
      print(e);
    }

    return myeventlist;

  }

}