import 'package:barcode_scan/barcode_scan.dart';
import 'package:bynextcourier/bloc/barcode_details_bloc.dart';
import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/helpers/task_utils.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/barcode_details.dart';
import 'package:bynextcourier/view/animated_button.dart';
import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:bynextcourier/view/bags_list.dart';
import 'package:bynextcourier/view/notes_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerPickupStep5 extends StatefulWidget {
  @override
  _CustomerPickupStep5State createState() => _CustomerPickupStep5State();
}

class _CustomerPickupStep5State extends State<CustomerPickupStep5> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, jobState) {
        if (jobState is ReadyTaskState) {
          return Scaffold(
            appBar: AppBar(
              title: AppBarTitle(task: jobState.task),
              bottom: bottomPlaceholder(jobState.rootTask != null),
            ),
            body: SafeArea(
              child: Container(
//                padding: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40,
                            child: Container(
                              width: 79,
                              height: 79,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    jobState.task.meta.userImage,
                                  ),
                                )
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 3,
                              left: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  jobState.task.location.street + ", " +
                                  jobState.task.location.streetLine2
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
//                                color: Colors.green,
                                  child: Text.rich(customerName(jobState?.task)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
//                      child: BlocBuilder<BarcodeDetailsBloc, BarcodeDetailsBlocState>(
                      child: BlocConsumer<BarcodeDetailsBloc, BarcodeDetailsBlocState>(
                        listener: (context, barcodeState) async {
                          if(barcodeState.error != null){
                            await showCustomDialog2(
                              context,
                              title: Text("Invalid barcode"),
//                              child: Text("There was an error processing your request, please try again"),
                              child: Text("${barcodeState.error.errors['error']}"),
                              buttons: [
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ]
                            );
                          }

                          if(barcodeState.newBarcode != null){
                            await showCustomDialog2(
                              context,
                              title: Text("Scan new barcode?"),
                              child: Text("Barcode ${barcodeState.newBarcode} scanned. Scan new barcode?"),
                              buttons: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text("Yes"),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        final scanResult = await scanBarCode(context);

                                        if(scanResult.type == ResultType.Barcode){
                                          context.bloc<BarcodeDetailsBloc>().add(AddBarcode(scanResult.rawContent));
                                        }
                                      },
                                    ),
                                    Divider(),
                                    FlatButton(
                                      child: Text("Close scanner"),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                        builder: (context, barcodeState) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 20)
                              .copyWith(bottom: 14),
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
                                        onPressed: getImage,
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
                                        onPressed: () async {
                                          final scanResult = await scanBarCode(context);

                                          if(scanResult.type == ResultType.Barcode){
                                            context.bloc<BarcodeDetailsBloc>().add(AddBarcode(scanResult.rawContent));
                                          }
                                        },
                                      )
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                BagsList(
                                  barcodes: barcodeState.barcodes,
                                ),
                                NotesList(
                                  notes: barcodeState.notes,
                                )
                              ] +
//                                (barcodeState.notes as List<OrderNote>).map((
//                                  e) =>
//                                  Container(
//                                    decoration: BoxDecoration(
//                                      border: Border.all(
//                                        color: Theme
//                                          .of(context)
//                                          .dividerTheme
//                                          .color
//                                      )
//                                    ),
//                                    child: Row(
//                                      children: <Widget>[
//                                        Container(
//                                          width: 40,
//                                          height: 40,
//                                          padding: EdgeInsets.all(1),
//                                          child: Image.network(
//                                            e.image,
//                                            fit: BoxFit.cover,
//                                          ),
//                                        ),
//                                        SizedBox(
//                                          width: 10,
//                                        ),
//                                        Text(e.text),
//                                      ],
//                                    ),
//                                  )).toList() +
                                [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                    ),
                                  ),
                                  BlocBuilder<
                                    LocationTrackerBloc,
                                    LocationTrackerBaseState>(
                                    builder: (context, locationState) {
                                      return AnimatedButton(
                                        child: Text(
                                          "Picked Up From Customer >>"),
                                        onHorizontalDragUpdate: (details) {
                                          if (details.primaryDelta > 40) {
                                            print("Drag right");
                                          }
                                        },
                                        condition: locationState
                                          .userArrivedAtDestinationLocation,
                                      );
                                    }
                                  )

                                ],
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Text("No task selected"),
          );
        }
      },
    );
  }

  Future getImage() async {
    final pickedFile = await getPhoto();
    printLabel('getImage pickedFile.path: ${pickedFile?.path}', 'TaskGoToLocationStep2Screen');
//    setState(() {
//      _image = pickedFile?.path != null ? File(pickedFile?.path) : null;
//    });

    String text = "";
    await showCustomDialog2(
      context,
      title: Text("Add Notes"),
      child: Column(
        children: <Widget>[
          Text("Please let us know what's this photo about. This field can't be empty."),
          TextField(
            onChanged: (val) => text = val,
          )
        ],
      ),
      buttons: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Upload"),
          onPressed: (){
            if (text.length > 0) {
              context.bloc<BarcodeDetailsBloc>().add(AddNote(OrderNote(
                text: text,
                image: pickedFile?.path,
                addedOn: DateTime.now(),
              )));
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }
}
