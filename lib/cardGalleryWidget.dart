import 'package:flutter/material.dart';
import 'package:test_task/unsplash.dart';

class CardGallery extends StatefulWidget {
  final UnsplashPhotoItem unsplashPhotoItem;

  const CardGallery({Key key, this.unsplashPhotoItem}) : super(key: key);

  @override
  _CardGalleryState createState() => _CardGalleryState();
}

class _CardGalleryState extends State<CardGallery> {
  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      onPressed: () {
        Navigator.pushNamed(context, "/image", arguments: widget.unsplashPhotoItem);
      },
      padding: EdgeInsets.all(4),
      child: Card(
        child: GridTile(
          footer: Container(
            padding: EdgeInsets.all(1),
            color: ThemeData.dark().primaryColor,
            alignment: Alignment.center,
            child: Text(widget.unsplashPhotoItem.author),
          ),
          child: Image.network(
            widget.unsplashPhotoItem.image.thumb,
            fit: BoxFit.cover,
            errorBuilder: (context, exception, stackTrace) {
              return Icon(Icons.error_outline);
            },
            loadingBuilder: (context, child, chunkEvent) {
              if (chunkEvent != null) {
                //Show animation loading
                return Center(
                  child: CircularProgressIndicator(
                    value: chunkEvent.cumulativeBytesLoaded / chunkEvent.expectedTotalBytes
                  ),
                );
              } else {
                return child;
              }
            },
          ),
        ),
      ),
    );
  }
}