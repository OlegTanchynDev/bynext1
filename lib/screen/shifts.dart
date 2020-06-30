import 'package:bynextcourier/bloc/schedule_bloc.dart';
import 'package:bynextcourier/generated/l10n.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/assigned_shift.dart';
import 'package:bynextcourier/model/schedule.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:bynextcourier/view/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShiftsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (context.bloc<ScheduleBloc>().state.selectedShifts.length > 0) {
          final willSave = await showCustomDialog<bool>(context,
                  title: 'Unsaved Changes',
                  message: 'You didn\'t save the changes, would you like to save or cancel?',
                  buttons: [
                    FlatButton(
                      child: Text('Don\'t save'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    FlatButton(
                      child: Text('Save changes'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ]) ??
              false;
          if (willSave) {
            context.bloc<ScheduleBloc>().add(ScheduleSave());
          }
          return Future.value(true);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: AppBarLogo(),
          centerTitle: true,
          actions: <Widget>[
            BlocBuilder<ScheduleBloc, ScheduleState>(
              builder: (context, listState) {
                return listState is ScheduleReady && listState.selectedShifts.isNotEmpty
                    ? FlatButton(
                        child: Text(S.of(context).save),
                        onPressed: () => context.bloc<ScheduleBloc>().add(ScheduleSave()),
                      )
                    : const SizedBox(width: 50);
              },
            ),
          ],
        ),
        body: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, listState) {
            return Stack(
              children: <Widget>[
                    _buildList(listState.upcoming, listState.assigned, listState.selectedShifts),
                  ] +
                  (listState is ScheduleLoading ? [CustomProgressIndicator()] : []),
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(List<Schedule> items, Map<int, AssignedShift> assigned, List<UpcomingShift> selectedShifts) {
    return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        itemBuilder: (context, pos) {
          final item = items[pos];

          final shifts = item.shifts;

          return Table(
            border: TableBorder.all(color: Colors.grey),
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.date + ', ' + item.dayName.toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                )
              ]),
              TableRow(children: [
                Table(
                  border: TableBorder.all(color: Colors.grey),
                  children: [
                    TableRow(
                        children: shifts
                            .map<Widget>(
                              (shift) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(shift.type.description, textAlign: TextAlign.center),
                              ),
                            )
                            .toList()),
                    TableRow(
                        children: shifts.map<Widget>((shift) {
                      final assignedShift = assigned[shift.id];
                      final selectedFlag = selectedShifts.contains(shift) ? AssignedShiftStatus.pending : null;
                      return Stack(alignment: Alignment.center, overflow: Overflow.visible, children: <Widget>[
                        IconButton(
                            icon: shiftIcon(selectedFlag ?? assignedShift?.status ?? AssignedShiftStatus.not_assigned,
                                shift.editAllowed),
                            onPressed: shiftAllowInteraction(assignedShift?.status) && shift.editAllowed
                                ? () {
                                    context.bloc<ScheduleBloc>().add(selectedShifts.contains(shift)
                                        ? ScheduleUpcomingDeselect(shift, item)
                                        : ScheduleUpcomingSelect(shift, item));
                                  }
                                : null)
                      ]);
                    }).toList())
                  ],
                )
              ]),
            ],
          );
        },
        separatorBuilder: (context, pos) => SizedBox(
              height: 16,
            ),
        itemCount: items.length);
  }

  Widget shiftIcon(AssignedShiftStatus assignedShiftStatus, bool editAllowed) {
    switch (assignedShiftStatus) {
      case AssignedShiftStatus.not_assigned:
        return ColorFiltered(
            colorFilter: ColorFilter.mode(editAllowed == true ? Colors.black54 : Colors.black12, BlendMode.srcIn),
            child: Image.asset('assets/images/checkbox-grey-unchecked.png'));
      case AssignedShiftStatus.pending:
        return ColorFiltered(
            colorFilter: ColorFilter.mode(editAllowed == true ? Colors.black54 : Colors.black12, BlendMode.srcIn),
            child: Image.asset('assets/images/checkbox-grey-question.png'));
      case AssignedShiftStatus.assigned:
        return ColorFiltered(
          colorFilter: const ColorFilter.mode(const Color(0xFF403D9C), BlendMode.srcIn),
          child: Image.asset('assets/images/checkbox-grey-checked.png'),
        );
      case AssignedShiftStatus.cancelled:
        return Image.asset('assets/images/checkbox-red-declined.png');
      case AssignedShiftStatus.cancelledByDispatcher:
        return Image.asset('assets/images/checkbox-red-declined.png');
      default:
        return Container();
    }
  }

  bool shiftAllowInteraction(AssignedShiftStatus assignedShiftStatus) {
    return AssignedShiftStatus.cancelledByDispatcher != assignedShiftStatus;
  }
}
