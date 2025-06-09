import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as log_dev;
import '../models/book_model.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import '../models/polish_model.dart';

class GoogleAPIService {
  final String url =
      'https://www.googleapis.com/books/v1/volumes?q=inauthor:arthur+c+clarke&maxResults=35';

  Future<List<Book>> fetchPotterBooks() async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return _parseBookJson(res.body);
    } else {
      throw Exception('Error: ${res.statusCode}');
    }
  }

  List<Book> _parseBookJson(String jsonStr) {
    final jsonMap = json.decode(jsonStr);
    final jsonList = (jsonMap['items'] as List);
    log_dev.log(jsonList.length.toString());
    return jsonList
        .map(
          (jsonBook) => Book(
            bookId: jsonBook['id'],
            title: jsonBook['volumeInfo']['title'],
            author: (jsonBook['volumeInfo']['authors'] as List).join(', '),
            thumbnailUrl:
                'https://res.cloudinary.com/dpeqsj31d/image/upload/v1707263739/avatar_2_2.png',
            // jsonBook['volumeInfo']['imageLinks']['smallThumbnail'],
          ),
        )
        .toList();
  }
}

class CredentialsProvider {
  CredentialsProvider();

  Future<ServiceAccountCredentials> get _credentials async {
    String file = await rootBundle.loadString(
      'assets/keys/teacher-project-3f7c9-c14c33373554.json',
    );
    return ServiceAccountCredentials.fromJson(file);
  }

  Future<AutoRefreshingAuthClient> get client async {
    AutoRefreshingAuthClient client = await clientViaServiceAccount(
      await _credentials,
      [VisionApi.cloudVisionScope],
    ).then((c) => c);
    return client;
  }
}

class RecognizeProvider {
  var client = CredentialsProvider().client;

  Future<String> imageText(String image) async {
    String sendback = "NOT*DETECTED";
    var vision = VisionApi(await client);
    var api = vision.images;
    var response = await api.annotate(
      BatchAnnotateImagesRequest.fromJson({
        "requests": [
          {
            "image": {"content": image},
            "features": [
              {"maxResults": 10, "type": "TEXT_DETECTION"},
            ],
          },
        ],
      }),
    );

    log_dev.log("within recognize provider method imageText!");
    response.responses?.forEach((data) {
      var props = data.textAnnotations;
      if (props != null) {
        var s = props[0].description;
        // log_dev.log(s.toString());
        if (s != null) {
          s.replaceAll('\n', ',');
          List lst = s.split('\n');
          for (var p in lst) {
            if (polishBrands.containsKey(p)) {
              sendback = polishBrands[p];
              break;
            }
          }
        }
        log_dev.log(sendback);
      }
    });
    return sendback;
  }

  Future<List<String>> imageColors(String image) async {
    List<String> sendback = [];
    var vision = VisionApi(await client);
    var api = vision.images;
    var response = await api.annotate(
      BatchAnnotateImagesRequest.fromJson({
        "requests": [
          {
            "image": {"content": image},
            "features": [
              {"maxResults": 10, "type": "IMAGE_PROPERTIES"},
            ],
          },
        ],
      }),
    );

    log_dev.log("within recognize provider method imageColors!");

    response.responses?.forEach((data) {
      var props = data.imagePropertiesAnnotation;
      if (props != null) {
        var c = props.dominantColors;
        if (c != null && c.colors != null) {
          for (var i = 0, counter = 0; i < c.colors!.length; i++) {
            String hex = '#';
            var tmp = c.colors![i];
            // log_dev.log(tmp.toJson().toString());
            if (tmp.score! > 0.05) {
              // var a = tmp.score;
              // var b = tmp.pixelFraction;
              // log_dev.log("$a $b");
              var red = tmp.color!.red;
              var green = tmp.color!.green;
              var blue = tmp.color!.blue;
              hex += red!.toInt().toRadixString(16).padLeft(2, '0');
              hex += green!.toInt().toRadixString(16).padLeft(2, '0');
              hex += blue!.toInt().toRadixString(16).padLeft(2, '0');
              sendback.add(hex);
              counter += 1;
              if (counter > 5) {
                break;
              }
            }
          }
        }
        log_dev.log(sendback.toString());
      }
    });
    return sendback;
  }
}
