import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_task/cardGalleryWidget.dart';
import 'package:test_task/unsplash.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  ScrollController _controller;
  List<UnsplashPhotoItem> _data;
  int _page = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _data = new List<UnsplashPhotoItem>();
    _controller = new ScrollController()..addListener(_scrollListener);
    _loadNext();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Container();
    if (_data.length == 0) {
      body = Container(
        alignment: Alignment.center,
        child: new CircularProgressIndicator( value: null, strokeWidth: 7.0, ),
      );
    } else {
      body = Container(
        padding: EdgeInsets.all(8),
        child: GridView.builder(
          controller: _controller,
          itemCount: _data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
          ),
          itemBuilder: (BuildContext context, int index)
             => CardGallery(unsplashPhotoItem: _data[index])
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery Unsplash"),
      ),
      body: body,
    );
  }


  void _scrollListener() {
    if (_controller.position.extentAfter < 500)
      _loadNext();
  }
  
  // Loading next lest with photo
  void _loadNext() {
    if (_isLoading)
      return;
    _isLoading = true;
    UnsplashAPI.getImagesList(_page++).then((value) => setState(() {
      _data.addAll(value);
      _isLoading = false;
    }));
  }
}