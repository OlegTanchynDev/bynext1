import 'package:bynextcourier/bloc/barcode_details_bloc.dart';
import 'package:bynextcourier/model/barcode_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesList extends StatelessWidget{
  final List<OrderNote> notes;

  const NotesList({Key key, this.notes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children:  (context.bloc<BarcodeDetailsBloc>().state.notes as List<OrderNote>).map((
          e) =>
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme
                  .of(context)
                  .dividerTheme
                  .color
              )
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  padding: EdgeInsets.all(1),
                  child: Image.network(
                    e.image,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(e.text),
              ],
            ),
          )).toList(),
      ),
    );
  }
}