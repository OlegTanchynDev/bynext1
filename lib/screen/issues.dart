import 'package:bynextcourier/bloc/issues_bloc.dart';
import 'package:bynextcourier/view/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IssuesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issues'),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: BlocBuilder<IssuesBloc, IssuesState>(
        builder: (context, state){
          final issues = state.issues;
          if ((issues?.length ?? 0) > 0) {
            return SingleChildScrollView(
              child: Column(
                children: issues.expand((element) =>
                [
                  ListTile(
                    title: Text(element.name),
                    trailing: Container(
                      width: 100,
                      child: Text(element.gradeEffect > 0 ? element.gradeEffect : "-"),
                    ),
                  ),
                  Divider(
                    height: 2,
                  )
                ]).toList(),
              ),
            );
          } else {
            return CustomProgressIndicator();
          }
        },
      ),
    );
  }

}