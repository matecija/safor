import 'package:intl/intl.dart';

class Event {

  final String id;
  final String name;
  final String description;
  final DateTime day;
  final DateTime start;
  final DateTime end;

  const Event(this.id,this.name,this.description,this.day,this.start,this.end);

  @override
  String toString() => ("( Title: $name, Description: $description, Day: " +DateFormat("dd/MM/yyyy").format(day)+
      " Start: "+ DateFormat("HH:mm").format(start)+", End:"+ DateFormat("HH:mm").format(end) +")");
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}


final kNow = DateTime.now();
final kFirstDay = DateTime(2021, 1 , 1);
final kLastDay = DateTime(kNow.year +1 , kNow.month , kNow.day);
