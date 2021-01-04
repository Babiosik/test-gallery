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
  bool _isError = false;

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
    Widget loadingIndicator = new CircularProgressIndicator( value: null, strokeWidth: 7.0, );
    if (_isError) {
      loadingIndicator = IconButton(
        icon: Icon(Icons.error_outline),
        onPressed: () => _loadNext()
      );
    }
    Widget body = Container();
    if (_data.length == 0) {
      body = Container(
        alignment: Alignment.center,
        child: loadingIndicator,
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
      _isLoading = false;
      _isError = value == null;
      if (!_isError)
        _data.addAll(value);
      else
        _showError(context);
    }));
  }

  void _showError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("There was an error loading data"),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () { Navigator.of(context).pop(); },
            ),
          ],
        );
      },
    );
  } 
}