import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JobCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final int distance;
  final int time;
  final String finalDestination;
  final int reward;

  JobCard({
    required this.imagePath,
    required this.title,
    required this.distance,
    required this.time,
    required this.finalDestination,
    required this.reward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                imagePath,
                width: 40,
                height: 40,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 20),
              SizedBox(width: 5),
              Text('$distance km'),
              SizedBox(width: 20),
              Icon(Icons.access_time, size: 20),
              SizedBox(width: 5),
              Text('${time ~/ 60}h ${time % 60}m'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Final Destination", style: TextStyle(fontSize: 12)),
                  Text(finalDestination,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('\$$reward',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {}, // Handle restrictions
                child: Text('Restrictions'),
              ),
              ElevatedButton(
                onPressed: () {}, // Handle job acceptance
                child: Text('Take Job'),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
