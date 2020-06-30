import 'package:flutter/material.dart';

class SalaryListItem extends StatelessWidget {
  final shiftItem;

  const SalaryListItem(this.shiftItem, {Key key, }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(child: Text('${shiftItem['shift_date']} - ${shiftItem['shift_type']}')),
          Text('Runs: ${shiftItem['number_of_runs']}'),
          SizedBox(width: 10,),
          Text('Total: ${shiftItem['shift_total_payment']}'),
        ],
      ),
    );
  }
}
