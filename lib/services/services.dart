import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReserva(DateTime day, DateTime start, DateTime end, String name, String description )async {
    CollectionReference reservas = _firestore.collection('reservas');
    reservas.add({
      'day' : day,
      'start' : start,
      'end' : end,
      'name' : name,
      'description' : description

    });

  }

  Future<bool> removeReserva(String id )async {
    try{
      CollectionReference reservas = _firestore.collection('reservas');
      reservas.doc(id).delete();
      return true;
    }catch(e){
      print(e.toString());
    }
    return false;
  }

}



class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signIn({email : String, password : String}) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  Future register({email : String, password : String, name: String}) async{
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      await userCredential.user!.updateProfile(displayName: name, photoURL: null);

      UserCredential userCredential2 = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential2.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

}