import 'package:flutter/material.dart';
import 'package:test_task/galleryScreen.dart';
import 'package:test_task/photoScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      onGenerateRoute: (route) {
        //Generate route for send arguments to PhotoScreen
        if (route.name == PhotoScreen.routeName)
          return MaterialPageRoute(
            builder: (context) => PhotoScreen(unsplashPhotoItem: route.arguments)
          );

        //Check unavaliable route
        assert(false, 'Need to implement ${route.name}');
        return null;
      },
      home: GalleryScreen(),
    );
  }
}
