
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safor/constants.dart';
import 'package:safor/services/services.dart';

class ReservarDialog extends AlertDialog{

  final FirestoreService _firestore = FirestoreService();

  TextEditingController description = TextEditingController();
  TextEditingController startcontroller = TextEditingController();
  TextEditingController endcontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();


  DateTime? start;
  DateTime? end;
  DateTime? day;

  //Widget buildDialog(BuildContext context, State state){
  Widget buildDialog(BuildContext context, State state, User user){
    return ListTile(
      title: Text('Reservar'),
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
                      width: 500,
                      height: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                'Choose Date',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5),
                              ),
                              InkWell(
                                onTap: () {
                                 _selectDate(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey[200]),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 40),
                                    textAlign: TextAlign.center,
                                    enabled: false,
                                    keyboardType: TextInputType.text,
                                    controller: datecontroller,
                                    decoration: InputDecoration(
                                        disabledBorder:
                                        UnderlineInputBorder(borderSide: BorderSide.none),
                                        // labelText: 'Time',
                                        contentPadding: EdgeInsets.only(top: 0.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Desde ',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _selectTime(context,true);
                                    },
                                    child: Container(
                                      width: 120,
                                      margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: Colors.grey[200]),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 24),
                                        textAlign: TextAlign.center,
                                        enabled: false,
                                        keyboardType: TextInputType.text,
                                        controller: startcontroller,
                                        decoration: InputDecoration(
                                            disabledBorder:
                                            UnderlineInputBorder(borderSide: BorderSide.none),
                                            // labelText: 'Time',
                                            contentPadding: EdgeInsets.all(5)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                children: <Widget>[
                                  Text(
                                    'Hasta',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _selectTime(context,false);
                                    },
                                    child: Container(
                                      width: 120,
                                      margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: Colors.grey[200]),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 24),
                                        textAlign: TextAlign.center,
                                        enabled: false,
                                        keyboardType: TextInputType.text,
                                        controller: endcontroller,
                                        decoration: InputDecoration(
                                            disabledBorder:
                                            UnderlineInputBorder(borderSide: BorderSide.none),
                                            // labelText: 'Time',
                                            contentPadding: EdgeInsets.all(5)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          TextFormField(
                            controller: description,
                            decoration:
                            InputDecoration(labelText: 'Description', ),
                          ),

                          ElevatedButton(
                              child: Text('Reservar'),
                              onPressed: () async {
                                try{
                                  //_firestore.addReserva(day!,start!,end!, "prueba1", "prueba");

                                  _firestore.addReserva(day!,start!,end!, user.displayName!, description.text);
                                  print("Reserva añadida con exito.");
                                  state.setState(() {});
                                  Navigator.pop(context);

                                }catch(e){
                                  print(e.toString());
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

 void _selectDate(BuildContext context) async {
      var picked = await showDatePicker(
       context: context,
       initialDate: DateTime.now(),
       initialDatePickerMode: DatePickerMode.day,
       firstDate: kFirstDay,
       lastDate: kLastDay);

      if(picked!=null){
        day = picked;
        datecontroller.text = DateFormat.MMMd().format(picked);
      }
 }

  void _selectTime(BuildContext context, bool startend ) async {
    var picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
   if(picked!=null){
     if(startend){
       start = DateTime( DateTime.now().year,DateTime.now().month,DateTime.now().day, picked.hour,picked.minute);
       startcontroller.text = picked.hour.toString() + ":"+ picked.minute.toString() ;
     }else{
       end = DateTime( DateTime.now().year,DateTime.now().month,DateTime.now().day, picked.hour,picked.minute);
       endcontroller.text = picked.hour.toString() + ":"+ picked.minute.toString() ;
     }
   }
  }


}