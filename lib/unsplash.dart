import 'dart:convert';
import 'package:http/http.dart';

class UnsplashAPI {
  static String _API_KEY = "Npz6x6oGUK5wQRQ-JlhwIiLu_XUsdMbZw-NnhpJz4iM";
  static String getPhotoURL = "https://api.unsplash.com/photos/?page=&per_page=30&client_id=";

  static String error = "no error";
  static Future<List<UnsplashPhotoItem>> getImagesList(int page) async {
    List<UnsplashPhotoItem> list = new List<UnsplashPhotoItem>();
    //Create link with parameters
    String link = getPhotoURL.replaceFirst("?page=", "?page=$page") + _API_KEY;
    //Send get request
    Response response;
    try {
      response = await get(link);
    } catch (e) {
      error = e.toString();
      return null;
    }
    
    //Checking response
    if (response.statusCode != 200) {
      error = "Status code ${response.statusCode}";
      return null;
    }
    
    //Try parse response json
    dynamic obj;
    try {
      obj = json.decode(response.body);
    } catch (e) {
      error = e.toString();
      return null;
    }

    //Parsing
    List<dynamic> unsplashListPhoto = obj;
    for (Map<String, dynamic> photo in unsplashListPhoto) {
      //Check important parameters
      if (photo["id"] == null || photo["urls"] == null)
        continue;
      String id = photo["id"];
      String author = "Unknown";

      Map<String, dynamic> urls = photo["urls"];
      //Check important parameters
      if (urls["full"] == null || urls["small"] == null)
        continue;

      //Check non-important parameters
      if (photo["user"] != null) {
        Map<String, dynamic> user = photo["user"];
        if (user["name"] != null)
          author = user["name"];
      }
      //Create and add parsed item to list
      list.add(new UnsplashPhotoItem(id, author, UnsplashImage.fromPartOfJson(urls)));
    }
    error = "no error 1";
    return list;
  }
}

// Object unsplash photo from the list
// With the most important parameters
class UnsplashPhotoItem {
  final String id;
  final String author;
  final UnsplashImage image;

  UnsplashPhotoItem(this.id, this.author, this.image);
}

// Additional object
// Have only image urls
class UnsplashImage {
  final String small;
  final String full;
  final String thumb;
  final String raw;
  final String regular;

  UnsplashImage(this.small, this.full, this.thumb, this.raw, this.regular);

  factory UnsplashImage.fromPartOfJson(Map<String, dynamic> map) => 
    UnsplashImage(map["small"], map["full"], map["thumb"], map["raw"], map["regular"]);
}