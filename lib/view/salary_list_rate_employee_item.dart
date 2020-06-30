import 'package:flutter/material.dart';

class SalaryListRateEmployeeItem extends StatelessWidget {
  final shiftItem;

  const SalaryListRateEmployeeItem(
    this.shiftItem, {
    Key key,
  }) : super(key: key);

  String getShiftTypeLabel(int id) {
    switch (id) {
      case 1:
        return 'Morning';
      case 3:
        return 'Evening';
      case 4:
        return 'Buisness';
      default:
        return 'Undefined';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('${shiftItem['working_date']} ${getShiftTypeLabel(shiftItem['shift_type_id'])}'),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: FittedBox(child: Text('Mileage Reimbursement: \$${shiftItem['mileage_reimbursement_payment']}'))),
              SizedBox(width: 10,),
              Expanded(child: Text('Total Hours: \$${shiftItem['working_hours']}')),
            ],
          ),
        ],
      ),
    );
  }
}
