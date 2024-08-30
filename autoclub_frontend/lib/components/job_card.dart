import 'package:autoclub_frontend/components/job_req_check.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:autoclub_frontend/models/job.dart';

class JobCard extends StatelessWidget {
  final TempJob job;
  final Car car;
  final Function handleJobAcceptance;

  JobCard({
    required this.job,
    required this.car,
    required this.handleJobAcceptance,
  });

  @override
  Widget build(BuildContext context) {
    bool requirementsMet = job.checkAllRequirements(car);

    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
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
          // Image and title
          Row(
            children: [
              Image.asset(
                job.companyLogo,
                width: 160,
                height: 50,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  job.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Distance, time
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 22,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text('${job.distance} km', style: TextStyle(fontSize: 18)),
              SizedBox(width: 20),
              Icon(
                Icons.access_time,
                size: 22,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text(
                '${job.getTravelTime(50) ~/ 60}h ${job.getTravelTime(50) % 60}m',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Final destination and reward
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Final Destination", style: TextStyle(fontSize: 12)),
                  Text(job.endLocationName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('\$${job.reward}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16),

          // Buttons or requirement message
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RequirementsPopup(
                        car: car,
                        requirements: job.requirements,
                      );
                    },
                  );
                }, // Handle restrictions
                style: ElevatedButton.styleFrom(primary: Colors.white10),
                child:
                    Text('Restrictions', style: TextStyle(color: Colors.white)),
              ),
              requirementsMet
                  ? ElevatedButton(
                      onPressed: () {
                        handleJobAcceptance(job);
                      }, // Handle job acceptance
                      child: Text(
                        'Take Job',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                    )
                  : Text(
                      'Car requirements not met',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 253, 167, 161),
                          fontSize: 16),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
