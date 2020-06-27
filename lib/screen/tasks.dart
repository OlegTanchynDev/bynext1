import 'package:bynextcourier/bloc/tasks_bloc.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/view/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: BlocBuilder<TasksListBloc, TasksListState>(
        builder: (context, listState) {
          if (listState is TasksListLoading) {
            return CustomProgressIndicator();
          } else if (listState is TasksListReady) {
            return _buildList(listState.tasks);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildList(List<Task> tasks) {
    return ListView.separated(
        itemBuilder: (context, pos) {
          final task = tasks[pos];
          final address = task.location.street +
              ((task.location.streetLine2?.length ?? 0) > 0 ? ', ' + task.location.streetLine2 : '');
          final cleaningOptions = <String>[];
          if ((task.meta?.wf ?? false) && (task.meta?.hd ?? false)) {
            cleaningOptions.add('WF (+HD)');
          } else {
            if (task.meta?.wf ?? false) {
              cleaningOptions.add('WF');
            }
            if (task.meta?.hd ?? false) {
              cleaningOptions.add('HD');
            }
          }
          if (task.meta?.dc ?? false) {
            cleaningOptions.add('DC');
          }
          if (task.meta?.wp ?? false) {
            cleaningOptions.add('LS');
          }

          String taskTypeImage;
          switch (task.type) {
            case 0:
              taskTypeImage = 'assets/images/header-supplies.png';
              break;
            case 2:
              taskTypeImage = 'assets/images/pick-up-icon.png';
              break;
            case 3:
              taskTypeImage = 'assets/images/delivery-icon.png';
              break;
            case 4:
              taskTypeImage = 'assets/images/header-laundromat.png';
              break;
            case 5:
              taskTypeImage = 'assets/images/header-laundromat.png';
              break;
          }
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            leading: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(1),
              child: CircleAvatar(
                backgroundImage: AssetImage(taskTypeImage),
                radius: 26,
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(child: Text(task.location.name)),
                (task.meta?.firstOrder ?? false)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(
                          'assets/images/heart-icon-fill.png',
                          width: 20,
                        ),
                      )
                    : Container(),
                Text(DateFormat.jm().format(task.actionTime))
              ],
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[Expanded(child: Text(
                  cleaningOptions.join(' | ')
              )), Text(address)],
            ),
          );
        },
        separatorBuilder: (context, pos) => Divider(),
        itemCount: tasks.length);
  }
}
