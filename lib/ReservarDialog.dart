
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservarDialog extends AlertDialog{

  TextEditingController description = TextEditingController();
  TextEditingController startcontroller = TextEditingController();
  TextEditingController endcontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();


  DateTime? start;
  DateTime? end;
  late State dialogstate;

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
                                  margin: EdgeInsets.only(top: 30),
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
                          Column(
                            children: <Widget>[
                              Text(
                                'Choose Time',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5),
                              ),
                              InkWell(
                                onTap: () {
                                  _selectTime(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 30),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey[200]),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 40),
                                    textAlign: TextAlign.center,
                                    enabled: false,
                                    keyboardType: TextInputType.text,
                                    //controller: _timeController,
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


                          ElevatedButton(
                              child: Text('Reservar'),
                              onPressed: () async {



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

 Future<DateTime?> _selectDate(BuildContext context) async {
   return  await showDatePicker(
       context: context,
       initialDate: DateTime.now(),
       initialDatePickerMode: DatePickerMode.day,
       firstDate: DateTime(2015),
       lastDate: DateTime(2101));
 }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
   return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

  }


}