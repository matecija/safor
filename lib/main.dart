import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:table_calendar/table_calendar.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return CalendarTable();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return CircularProgressIndicator();
        },
      ),
    );


  }
}


class CalendarTable extends StatefulWidget {
  @override
  _CalendarTableState createState() => _CalendarTableState();
}

class _CalendarTableState extends State<CalendarTable> {

  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _getEvents();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }


  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> retrievedData = [];

  Future _getEvents() async{
     var collectionReferece = await FirebaseFirestore.instance.collection('reservas');
     collectionReferece.get().then((collectionSnapshot){
       retrievedData = collectionSnapshot.docs.toList();
     });
     print(retrievedData);
   }


  List<Event> _getEventsForDay(DateTime day) {

    List<Event> listeventday = [];
    for(Event e in retrievedData){
      if(e.day.day == day.day){
        listeventday.add(e);
      }
    }
  return listeventday;
  }


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: true,
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),

/*
          StreamBuilder(
            stream: Firestore.instance.collection('reservas').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator(),);
              }else{

                return ListView(
                  children: snapshot.data!.documents.map((document) {
                    return Center(
                      child: Container(
                        child: Text("Title:"+ document['title']),
                      ),
                    );
                  }).toList(),
                );
              }
            }
          ),*/
        ],
      ),
    );
  }
}