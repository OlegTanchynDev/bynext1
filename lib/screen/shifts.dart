import 'package:bynextcourier/bloc/schedule_bloc.dart';
import 'package:bynextcourier/model/schedule.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:bynextcourier/view/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShiftsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarLogo(),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, listState) {
          if (listState is ScheduleLoading) {
            return CustomProgressIndicator();
          } else if (listState is ScheduleReady) {
            return _buildList(listState.items);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildList(List<Schedule> items) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        itemBuilder: (context, pos) {
          final item = items[pos];
          return Table(
              border: TableBorder.all(color: Colors.grey),
            children: [
              TableRow(children: [Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item.date + ', ' + item.dayName.toUpperCase(), textAlign: TextAlign.center,),
              )]),
              TableRow(children: [
                Table(border: TableBorder.all(color: Colors.grey), children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Morning', textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Evening', textAlign: TextAlign.center,),
                    ),
                  ]),
                  TableRow( children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                    ),
                  ])
                ],)
              ]),

            ],
          );
        },
        separatorBuilder: (context, pos) => SizedBox(height: 16,),
        itemCount: items.length);
  }
}
