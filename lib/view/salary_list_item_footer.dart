import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SalaryListItemFooter extends StatelessWidget {
  final List shiftsDetails;

  const SalaryListItemFooter(
    this.shiftsDetails, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    num totalHr = 0;
    num totalTraining = 0;
    num totalMileage = 0;
    num totalTipping = 0;

    this.shiftsDetails.forEach((element) {
      totalHr += (element['working_hours'] as num);
      totalTraining += (element['training_total_payment'] as num);
      totalMileage += (element['mileage_reimbursement_payment'] as num);
      totalTipping += (element['tipping'] as num);
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(flex: 3,child: Text('REGULAR HOURS:')),
              SizedBox(
                width: 10,
              ),
              Expanded(flex: 2,child: Text('$totalHr hr')),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(flex: 3,child: Text('TRAINING ADDON:')),
              SizedBox(
                width: 10,
              ),
              Expanded(flex: 2,child: Text('\$$totalTraining')),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Text(
                    'MILEAGE REIMBURSEMENT:',
                  )),
              SizedBox(
                width: 10,
              ),
              Expanded(flex: 2, child: Text('\$$totalMileage')),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(flex: 3,child: Text('EXTRAS:')),
              SizedBox(
                width: 10,
              ),
              Expanded(flex: 2,child: Text('\$$totalTipping')),
            ],
          ),
        ],
      ),
    );
  }
}
