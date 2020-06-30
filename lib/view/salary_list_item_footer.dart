import 'package:flutter/material.dart';

class SalaryListItemFooter extends StatelessWidget {

  const SalaryListItemFooter({Key key, }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text('REGULAR HOURS:')),
              SizedBox(width: 10,),
              Expanded(child: Text('0 hr')),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: Text('TRAINING ADDON:')),
              SizedBox(width: 10,),
              Expanded(child: Text('\$0.0')),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: Text('MILEAGE REIMBURSEMENT:')),
              SizedBox(width: 10,),
              Expanded(child: Text('\$0.0')),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: Text('EXTRAS:')),
              SizedBox(width: 10,),
              Expanded(child: Text('\$0')),
            ],
          ),
        ],
      ),
    );
  }
}
