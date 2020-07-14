import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TaskNotesView extends StatelessWidget {
  final bool showTime;

  const TaskNotesView({Key key, this.showTime = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, taskState) {
        final task = taskState.task;
        final borderSide = BorderSide(color: Theme.of(context).dividerTheme.color);
        final notes = task.notes;
        // ?? 'Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 18,
              ),
              showTime
                  ? Text(
                      '${task.meta.startTime != null ? DateFormat.jm().format(task.meta.startTime) : ''} - ${task.meta.endTime != null ? DateFormat.jm().format(task.meta.endTime) : ''}',
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerTheme.color)),
                      child: Padding(padding: EdgeInsets.all(9.0), child: Text(task.location.street)),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border(right: borderSide, bottom: borderSide, top: borderSide)),
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 9.0, horizontal: 35.0),
                        child: Text(task.location.streetLine2)),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
//                            alignment: Alignment.center,
                      decoration:
                          BoxDecoration(border: Border(left: borderSide, bottom: borderSide, right: borderSide)),
                      child: Padding(padding: EdgeInsets.all(9.0), child: Text('Notes')),
                    ),
                  ),
                ],
              ),
              notes != null
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
//                            alignment: Alignment.center,
                            decoration:
                                BoxDecoration(border: Border(left: borderSide, bottom: borderSide, right: borderSide)),
                            child: Padding(
                                padding: EdgeInsets.all(9.0),
                                child: Text(
                                  'Notes: $notes',
                                  textAlign: TextAlign.justify,
                                )),
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        );
      },
    );
  }
}
