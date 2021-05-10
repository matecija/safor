import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safor/services/model.dart';
import 'LoginDialog.dart';
import 'RegisterDialog.dart';
import 'ReservarDialog.dart';
import 'constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:scoped_model/scoped_model.dart';

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

            return ScopedModel<AppModel>(
                model: AppModel(),
                child: FutureBuilder(
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
                )
            );
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
  List<Event> retrievedData  = [];


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

  void _getEvents() async {
    print("getevents start");
    List<Event> data  = [];

     try{
        await FirebaseFirestore.instance.collection('reservas').snapshots().forEach((snapshot) {
          print("Data clear");
          data.clear();
          for (var message in snapshot.docs) {

              print("Firebase Data -> ${message.data()}");
              data.add(Event(message['name'],
                  message['description'],
                  (message['day'] as Timestamp).toDate(),
                  (message['start'] as Timestamp).toDate(),
                  (message['end'] as Timestamp).toDate()));
          }

          print("Data: " + data.toString());
          setState(() {  retrievedData = data;  });

        });
    }catch (e) {
       e.toString();
    }


/*
    CollectionReference _collectionRef =
    await FirebaseFirestore.instance.collection('reservas');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    for(var message in querySnapshot.docs ){
      data.add(Event(message['name'],
          message['description'],
          (message['day'] as Timestamp).toDate(),
          (message['start'] as Timestamp).toDate(),
          (message['end'] as Timestamp).toDate()));
    }
*/




    /*await for (var snapshot in FirebaseFirestore.instance.collection('reservas').doc) {
      for (var message in snapshot.docs) {
        try{
          print("Firebase Data -> ${message.data()}");
          data.add(Event(message['name'],
              message['description'],
              (message['day'] as Timestamp).toDate(),
              (message['start'] as Timestamp).toDate(),
              (message['end'] as Timestamp).toDate()));

        }catch(e){
          print("--- Error! : $e");
        }
      }
    }*/
  }

  List<Event> _getEventsForDay(DateTime day) {
  List<Event>  listeventday=[];
    for(Event e in retrievedData ){
      if(e.day.day == day.day &&
        e.day.month == day.month &&
        e.day.year == day.year)
        listeventday.add(e);
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
    return ScopedModelDescendant<AppModel>(
      builder: (context,child,model){
        return Scaffold(
          appBar: AppBar(
            title: Text("Reservas Safor"),
          ),

          drawer: Drawer(

            child: ListView(
              children: [
                DrawerHeader(

                  child: Row(
                    children: [

                      if(model.currentUser != null && model.currentUser!.photoURL != null) Align(
                        alignment: Alignment.centerLeft,
                        child: Image.network(model.currentUser!.photoURL!),
                        ),

                      if(model.currentUser != null && model.currentUser!.photoURL == null)Align(
                        alignment: Alignment.centerLeft,
                        child: Image.network("https://thumbs.dreamstime.com/b/default-avatar-profile-flat-icon-social-media-user-vector-portrait-unknown-human-image-default-avatar-profile-flat-icon-184330869.jpg"),
                      ),
                      
                      if(model.currentUser == null)Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                        ),
                      ),

                      if(model.currentUser != null)
                        Container(
                          constraints: BoxConstraints(maxWidth: 200),
                         child :Text(
                              model.currentUser!.displayName!,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                              overflow: TextOverflow.clip,
                          ),
                        ),


                    ],
                  ),
                  decoration: BoxDecoration(color: Colors.blueAccent),
                ),




                if(model.currentUser == null) LoginDialog().buildDialog(context, this, model.currentUser),
                if(model.currentUser == null) RegisterDialog().buildDialog(context, this, model.currentUser),
                if(model.currentUser != null) ReservarDialog().buildDialog(context, this, model.currentUser!,retrievedData),
                if(model.currentUser != null) ListTile(
                  title: Text("Sign out"),
                  onTap: () {
                    model.logoutModelFunc();
                  },
                )
              ],
            ),
          ),

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
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: Padding(
                              padding : EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: SizedBox(
                                //height: 60.0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(value[index].name),
                                      Text(value[index].description),
                                      Text("Reservado de "+ DateFormat("HH:mm").format(value[index].start)+ " a "+ DateFormat("HH:mm").format(value[index].end)),
                                    ],
                                  )
                              ),
                            )
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
    }
    );
  }
}