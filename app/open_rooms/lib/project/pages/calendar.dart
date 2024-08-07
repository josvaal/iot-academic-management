import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:open_rooms/project/classes/date_day.dart';
import 'package:open_rooms/project/classes/event.dart';
import 'package:open_rooms/project/classes/events.dart';
import 'package:open_rooms/project/utils.dart';
import 'package:open_rooms/project/widgets/custom_button.dart';
import 'package:open_rooms/project/widgets/custom_text_field.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
    required this.roomId,
  });

  final String? roomId;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String? roomId;
  String? currentUserUID = FirebaseAuth.instance.currentUser?.uid;
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
    0,
    0,
    0,
  );
  DateTime? _selectedDay;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _eventSubjectController = TextEditingController();
  final TextEditingController _eventPinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      roomId = widget.roomId;
    });
    DatabaseReference reservationsRef = FirebaseDatabase.instance.ref(
      'labs/$roomId/reservations',
    );
    reservationsRef.onValue.listen((DatabaseEvent event) {
      final Map<DateDay, List<Event>> tempEvents = {};
      for (final child in event.snapshot.children) {
        final dateDay = parseDateDay(child);
        final event = parseEvent(child);

        if (dateDay != null && event != null) {
          tempEvents.putIfAbsent(dateDay, () => []).add(event);
        }

        setState(() {
          events = LinkedHashMap<DateDay, List<Event>>.from(tempEvents);
        });
        // print(events);
      }
    });
    _selectedDay = _focusedDay;
    if (_selectedDay != null) {
      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    } else {
      // Handle the case when _selectedDay is null
      _selectedEvents = ValueNotifier([]);
    }
    _startTime = TimeOfDay(
      hour: roundStartTime(_focusedDay).hour,
      minute: roundStartTime(_focusedDay).minute,
    );
    _endTime = TimeOfDay(
      hour: roundEndTime(_focusedDay).hour,
      minute: roundEndTime(_focusedDay).minute,
    );
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    final dateDay = DateDay(day.year, day.month, day.day);
    return events[dateDay] ?? [];
  }

  void _addEvent() {
    DatabaseReference reservationsRef = FirebaseDatabase.instance.ref(
      'labs/$roomId/reservations',
    );
    DatabaseReference newReservationRef = reservationsRef.push();

    newReservationRef.set({
      "day": _selectedDay?.day,
      "month": _selectedDay?.month,
      "year": _selectedDay?.year,
      "start_hour": _startTime.hour,
      "start_minute": _startTime.minute,
      "end_hour": _endTime.hour,
      "end_minute": _endTime.minute,
      "title": _eventTitleController.text,
      "subject": _eventSubjectController.text,
      "teacher_uid": currentUserUID,
      "pin": _eventPinController.text,
    });
    // setState(() {
    //   _selectedEvents.value = _getEventsForDay(_selectedDay!);
    // });

    _eventTitleController.clear();
    _eventSubjectController.clear();
  }

  void _handleReservation(BuildContext context) {
    _addEvent();
    Navigator.of(context).pop();
    _selectedEvents.value = _getEventsForDay(_selectedDay!);
  }

  void _changeReservationStart(TimeOfDay value) {
    setState(() {
      _startTime = value;
    });
    print(value);
  }

  void _changeReservationEnd(TimeOfDay value) {
    setState(() {
      _endTime = value;
    });
    print(value);
  }

  void handleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          scrollable: true,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Añadir reserva",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: CustomButton(
                    title: "Cancelar",
                    bg: Colors.red,
                    fg: Colors.black,
                    action: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child: CustomButton(
                    title: "Reservar",
                    bg: Colors.blue,
                    fg: Colors.black,
                    action: () {
                      _handleReservation(context);
                    },
                  ),
                ),
              ],
            ),
          ],
          content: Column(
            children: [
              CustomTextField(
                controller: _eventTitleController,
                label: "Título",
                icon: Icons.title,
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomTextField(
                controller: _eventSubjectController,
                label: "Asignatura",
                icon: Icons.book,
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomTextField(
                type: TextInputType.number,
                size: 4,
                controller: _eventPinController,
                label: "PIN",
                icon: Icons.pin,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Inicio",
                    style: TextStyle(color: Colors.white),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _startTime.format(context),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? newEventTime = await showTimePicker(
                        context: context,
                        initialTime: _startTime,
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              timePickerTheme: TimePickerThemeData(
                                backgroundColor: Colors.black,
                                hourMinuteColor: WidgetStateColor.resolveWith(
                                  (states) =>
                                      states.contains(WidgetState.selected)
                                          ? Colors.blue
                                          : Colors.blue.withOpacity(0.1),
                                ),
                                hourMinuteTextColor:
                                    WidgetStateColor.resolveWith(
                                  (states) =>
                                      states.contains(WidgetState.selected)
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                dayPeriodColor: WidgetStateColor.resolveWith(
                                  (states) =>
                                      states.contains(WidgetState.selected)
                                          ? Colors.blue
                                          : Colors.blue.withOpacity(0.1),
                                ),
                                dayPeriodBorderSide: const BorderSide(width: 0),
                                dayPeriodTextColor:
                                    WidgetStateColor.resolveWith(
                                  (states) =>
                                      states.contains(WidgetState.selected)
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                entryModeIconColor: Colors.blue,
                                dialBackgroundColor:
                                    Colors.blue.withOpacity(0.1),
                                dialHandColor: Colors.blue,
                                dialTextColor: WidgetStateColor.resolveWith(
                                  (states) =>
                                      states.contains(WidgetState.selected)
                                          ? Colors.black
                                          : Colors.white,
                                ),
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateColor.resolveWith(
                                    (states) => Colors.blue,
                                  ),
                                  foregroundColor: WidgetStateColor.resolveWith(
                                    (states) => Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            child: child ?? Container(),
                          );
                        },
                      );
                      if (newEventTime != null) {
                        _changeReservationStart(newEventTime);
                        //RECURSION GOOOOOOOOOOOOOOOOOOOD
                        Navigator.of(context).pop();
                        handleDialog();
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Final",
                    style: TextStyle(color: Colors.white),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _endTime.format(context),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? newEventTime = await showTimePicker(
                        context: context,
                        initialTime: _endTime,
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              timePickerTheme: TimePickerThemeData(
                                backgroundColor: Colors.black,
                                hourMinuteColor: WidgetStateColor.resolveWith(
                                  (states) =>
                                      states.contains(WidgetState.selected)
                                          ? Colors.blue
                                          : Colors.blue.withOpacity(0.1),
                                ),
                                hourMinuteTextColor:
                                    WidgetStateColor.resolveWith(
                                  (states) =>
                                      states.contains(WidgetState.selected)
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                dayPeriodColor: WidgetStateColor.resolveWith(
                                  (states) =>
                                      states.contains(WidgetState.selected)
                                          ? Colors.blue
                                          : Colors.blue.withOpacity(0.1),
                                ),
                                dayPeriodBorderSide: BorderSide(width: 0),
                                dayPeriodTextColor:
                                    WidgetStateColor.resolveWith(
                                  (states) =>
                                      states.contains(WidgetState.selected)
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                entryModeIconColor: Colors.blue,
                                dialBackgroundColor:
                                    Colors.blue.withOpacity(0.1),
                                dialHandColor: Colors.blue,
                                dialTextColor: WidgetStateColor.resolveWith(
                                  (states) =>
                                      states.contains(WidgetState.selected)
                                          ? Colors.black
                                          : Colors.white,
                                ),
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateColor.resolveWith(
                                    (states) => Colors.blue,
                                  ),
                                  foregroundColor: WidgetStateColor.resolveWith(
                                    (states) => Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            child: child ?? Container(),
                          );
                        },
                      );
                      if (newEventTime != null) {
                        _changeReservationEnd(newEventTime);
                        //RECURSION GOOOOOOOOOOOOOOOOOOOD
                        Navigator.of(context).pop();
                        handleDialog();
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Reservas",
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade200,
        onPressed: handleDialog,
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TableCalendar(
              headerStyle: HeaderStyle(
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                ),
                formatButtonTextStyle: const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                formatButtonDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blue.withOpacity(0.2),
                ),
              ),
              locale: 'en_US',
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              calendarBuilders: CalendarBuilders(
                singleMarkerBuilder: (context, date, _) {
                  return Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    width: 4.0,
                    height: 4.0,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                todayTextStyle: const TextStyle(color: Colors.white),
                defaultTextStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                ),
                weekendTextStyle: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                outsideDaysVisible: false,
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade200,
                ),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.2),
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedEvents.value = _getEventsForDay(selectedDay);
                  });
                }
              },
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
            const SizedBox(height: 10.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 3,
                          ),
                        ),
                        child: InkWell(
                          splashColor: Colors.white10,
                          highlightColor: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => print(events),
                          child: ListBody(
                            children: [
                              ListTile(
                                title: Text(
                                  "${value[index].startString()} - ${value[index].endString()}",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                subtitle: Text(
                                  "${value[index].subject} - ${value[index].title}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
