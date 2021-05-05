// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;
  final String description;
  final DateTime day;
  final DateTime start;
  final DateTime end;

  const Event(this.title,this.description,this.day,this.start,this.end);

  String getCompleteInfo() => ("Title: $title, Description: $description, Start: $start, End: $end");

  @override
  String toString() => title;
}
/*
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(2020, 10, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    DateTime.now(): [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });
*/
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}


final kNow = DateTime.now();
final kFirstDay = DateTime(2021, 1 , 1);
final kLastDay = DateTime(kNow.year +1 , kNow.month , kNow.day);
