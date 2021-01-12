import 'package:flutter/material.dart';
import 'package:Unsplash_Gallery/unsplash.dart';

class CardGallery extends StatelessWidget {
  final UnsplashPhotoItem unsplashPhotoItem;

  const CardGallery({Key key, this.unsplashPhotoItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      onPressed: () {
        //Open image
        Navigator.pushNamed(context, "/image", arguments: unsplashPhotoItem);
      },
      padding: EdgeInsets.all(4),
      child: Card(
        child: GridTile(
          footer: Container(
            padding: EdgeInsets.all(1),
            color: ThemeData.dark().primaryColor,
            alignment: Alignment.center,
            child: Text(
              unsplashPhotoItem.author,
              style: TextStyle(color: Colors.blue[700]),
            ),
          ),
          child: Image.network(
            unsplashPhotoItem.image.thumb,
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