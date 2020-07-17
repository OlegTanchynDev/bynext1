import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatelessWidget{
  final ImageProvider imageProvider;

  const ImageScreen({Key key, this.imageProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarLogo(),
        centerTitle: true,
      ),
      body: PhotoView(
        backgroundDecoration: BoxDecoration(
          color: Colors.grey[300]
        ),
        minScale: PhotoViewComputedScale.contained,
//        imageProvider: CachedNetworkImageProvider(url),
        imageProvider: imageProvider,
      ),
    );
  }
}