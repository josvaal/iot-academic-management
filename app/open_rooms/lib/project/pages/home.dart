import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_rooms/project/widgets/panel_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Panel principal",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  PanelItem(
                    title: "Desbloquear",
                    icon: Icons.password,
                    action: () => context.go("/door"),
                  ),
                  PanelItem(
                    title: "Laboratorios",
                    icon: Icons.door_sliding,
                    action: () => context.go("/labs"),
                  ),
                  PanelItem(
                    title: "Perfil",
                    icon: Icons.account_circle,
                    action: () => context.go("/profile"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
