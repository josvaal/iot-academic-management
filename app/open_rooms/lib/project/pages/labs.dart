import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_rooms/project/widgets/panel_item.dart';

class Labs extends StatefulWidget {
  const Labs({super.key});

  @override
  State<Labs> createState() => _LabsState();
}

class _LabsState extends State<Labs> {
  List<DataSnapshot>? labs;

  @override
  void initState() {
    super.initState();
    DatabaseReference labsRef = FirebaseDatabase.instance.ref('labs');
    labsRef.onValue.listen((DatabaseEvent event) {
      List<DataSnapshot> result = [];
      for (final child in event.snapshot.children) {
        // print(child);
        result.add(child);
      }
      setState(() {
        labs = result;
      });
    });
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
        child: labs == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: labs!.map(
                        (lab) {
                          return PanelItem(
                            title: lab.child("title").value.toString(),
                            icon: Icons.meeting_room_rounded,
                            action: () => context.push("/calendar/${lab.key}"),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
