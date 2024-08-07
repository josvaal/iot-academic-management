import 'package:flutter/material.dart';

class PanelItem extends StatelessWidget {
  const PanelItem({
    super.key,
    required this.icon,
    required this.title,
    required this.action,
  });

  final IconData icon;
  final String title;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: <Color>[
            Colors.blue,
            Colors.blue.shade200,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          splashColor: Colors.white10,
          highlightColor: Colors.white10,
          borderRadius: BorderRadius.circular(12),
          onTap: action,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.black,
                size: 50,
              ),
              const SizedBox(height: 5.0),
              Text(
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
