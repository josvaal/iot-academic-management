import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_rooms/project/widgets/custom_button.dart';
import 'package:pinput/pinput.dart';

class Door extends StatefulWidget {
  const Door({super.key});

  @override
  State<Door> createState() => _DoorState();
}

TimeOfDay? start;
TimeOfDay? end;
bool isOpen = false;
String? error;
String? pin;
TextEditingController pinController = TextEditingController();

class _DoorState extends State<Door> {
  bool loading = true;
  String? currentUserUID = FirebaseAuth.instance.currentUser?.uid;
  List<DataSnapshot>? labs;
  List<Object>? labsFilter;
  Map<dynamic, dynamic>? currentReservation;
  String? currentLabID;

  late DateTime now;
  late int currentHour;
  late int currentMinute;

  @override
  void initState() {
    super.initState();
    DatabaseReference labsRef = FirebaseDatabase.instance.ref('labs');
    labsRef.onValue.listen((DatabaseEvent event) {
      List<DataSnapshot> result = [];
      List<Object> filteredReservations = [];
      now = DateTime.now();
      currentHour = now.hour;
      currentMinute = now.minute;
      bool? currentBool = false;
      for (final child in event.snapshot.children) {
        result.add(child);
        var reservations =
            child.child('reservations').value as Map<dynamic, dynamic>?;
        if (reservations != null) {
          reservations.forEach((key, value) {
            if (value is Map && value['teacher_uid'] == currentUserUID) {
              filteredReservations.add(value);

              int? startHour = value['start_hour'] as int?;
              int? startMinute = value['start_minute'] as int?;
              int? endHour = value['end_hour'] as int?;
              int? endMinute = value['end_minute'] as int?;

              if (startHour != null &&
                  startMinute != null &&
                  endHour != null &&
                  endMinute != null) {
                DateTime startTime = DateTime(
                    now.year, now.month, now.day, startHour, startMinute);
                DateTime endTime =
                    DateTime(now.year, now.month, now.day, endHour, endMinute);

                if (now.isAfter(startTime) && now.isBefore(endTime)) {
                  currentReservation = value;
                  currentLabID = child.key;
                  currentBool = child.child("open").value as bool?;
                }
              }
            }
          });
        }
      }
      setState(() {
        loading = false;
        labs = result;
        labsFilter = filteredReservations;
        isOpen = currentBool!;

        if (currentReservation != null) {
          start = TimeOfDay(
            hour: currentReservation?['start_hour'] ?? 0,
            minute: currentReservation?['start_minute'] ?? 0,
          );
          end = TimeOfDay(
            hour: currentReservation?['end_hour'] ?? 0,
            minute: currentReservation?['end_minute'] ?? 0,
          );
        } else {
          start = null;
          end = null;
        }
      });
      print(currentReservation.toString());
    });
  }

  final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: const TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.blue),
    ),
  );

  void handleDoor() async {
    if (pinController.text == currentReservation?["pin"]) {
      DatabaseReference ref = FirebaseDatabase.instance.ref(
        "labs/$currentLabID",
      );

      await ref.update({
        "open": !isOpen!,
      });
    } else {
      setState(() {
        pinController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : currentReservation != null
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                currentReservation?["title"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Desde las ${start?.format(context)} hasta las ${end?.format(context)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                "Ingrese su PIN",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.25),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Pinput(
                                keyboardType: TextInputType.number,
                                controller: pinController,
                                defaultPinTheme: defaultPinTheme,
                                isCursorAnimationEnabled: true,
                                length: 4,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              CustomButton(
                                bg: Colors.blue,
                                fg: Colors.black,
                                action: handleDoor,
                                title:
                                    isOpen ? "Cerrar puerta" : "Abrir puerta",
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      children: [
                        const Text(
                          "No tienes una reservación.",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        CustomButton(
                          bg: Colors.blue,
                          fg: Colors.black,
                          action: () => context.go("/labs"),
                          title: "Reservar ahora",
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
