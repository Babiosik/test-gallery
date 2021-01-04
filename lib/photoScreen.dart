import 'package:flutter/material.dart';
import 'package:test_task/unsplash.dart';

class PhotoScreen extends StatefulWidget {
  static final String routeName = "/image";
  final UnsplashPhotoItem unsplashPhotoItem;

  const PhotoScreen({Key key, this.unsplashPhotoItem}) : super(key: key);

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery Unsplash / Image"),
      ),
      body: Center(
        child: Image.network(
          widget.unsplashPhotoItem.image.raw,
          fit: BoxFit.cover,
          errorBuilder: (context, exception, stackTrace) {
            return Icon(Icons.error_outline);
          },
          loadingBuilder: (context, child, chunkEvent) {
            if (chunkEvent != null) {
              //Show progress loading image
              double progress = chunkEvent.cumulativeBytesLoaded / chunkEvent.expectedTotalBytes;
              return Center(
                child: CircularProgressIndicator(
                  value: progress > 0.1 ? progress : null
                ),
              );
            } else {
              return child;
            }
          },
        ),
      ),
    );
  }
}