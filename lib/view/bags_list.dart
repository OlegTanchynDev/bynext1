import 'package:bynextcourier/bloc/barcode_details_bloc.dart';
import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/model/barcode_details.dart';
import 'package:bynextcourier/view/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BagsList extends StatefulWidget{
  final List<BarcodeDetails> barcodes;

  const BagsList({Key key, this.barcodes}) : super(key: key);

  @override
  _BagsListState createState() => _BagsListState();
}

class _BagsListState extends State<BagsList> {
  List<BarcodeDetails> _barcodes;

  @override
  void initState() {
    _barcodes = widget.barcodes;
//    _barcodes = context.bloc<BarcodeDetailsBloc>().state.barcodes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      padding: EdgeInsets.symmetric(horizontal: 20).copyWith(
//        bottom: 14),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "SNAP PHOTO",
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Image.asset("assets/images/checkbox-grey-checked.png")
                    ],
                  ),
                  onPressed: () {},
                )
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "SCAN BARCODE",
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Image.asset("assets/images/checkbox-grey-checked.png")
                    ],
                  ),
                  onPressed: () {},
                )
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text("Bags "),
              Text(_barcodes.length.toString())
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ] +
          _barcodes.expand((e) =>
          [
            Container(
              padding: EdgeInsets.all(9),
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
                  Text(e.type.toString()),
//                VerticalDivider(
//                  width: 4,
//                  color: Colors.black,
//                ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(e.barcode),
                  Expanded(
                    child: Container(),
                  ),
                  GestureDetector(
                    child: Text(
                      "Remove",
                    ),
                    onTap: () {
                      _barcodes.remove(e);
                      setState(() {
                        _barcodes = _barcodes;
                      });
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 1,
            )
          ]).toList()
      ),
    );
  }
}