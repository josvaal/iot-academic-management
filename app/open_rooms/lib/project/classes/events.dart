import 'dart:collection';

import 'package:open_rooms/project/classes/date_day.dart';
import 'package:open_rooms/project/classes/event.dart';

//DONE: Implementar el map nuevo con la clase creada "DateDay" integrado con RealTime Database.
LinkedHashMap<DateDay, List<Event>> events =
    LinkedHashMap<DateDay, List<Event>>(
  equals: (p0, p1) => p0 == p1,
  hashCode: (p0) => p0.hashCode,
);
