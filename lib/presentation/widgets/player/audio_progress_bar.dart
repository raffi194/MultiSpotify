import 'package:flutter/material.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: 0,
          min: 0,
          max: 100,
          inactiveColor: Colors.white24,
          activeColor: Colors.greenAccent,
          onChanged: (v) {},
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("0:00", style: TextStyle(color: Colors.white54, fontSize: 12)),
            Text("3:45", style: TextStyle(color: Colors.white54, fontSize: 12))
          ],
        )
      ],
    );
  }
}
