import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final double currentStat;
  final double newStat;
  final double maxStat;
  final double? improveStat;

  StatBar(
      {required this.currentStat,
      required this.newStat,
      this.maxStat = 10,
      this.improveStat});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: newStat / maxStat,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          (improveStat != null)
              ? FractionallySizedBox(
                  widthFactor: improveStat! / maxStat,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 83, 206, 144),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                )
              : Container(),
          FractionallySizedBox(
            widthFactor: currentStat / maxStat,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
