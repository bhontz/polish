import 'package:flutter/material.dart';
import 'package:google_vision_flutter/google_vision_flutter.dart';
import 'example_base.dart';

class AboutPage extends ExampleBase {
  // was StatelessWidget
  // const AboutPage({super.key});  this was the constructor

  AboutPage({super.key, required super.googleVision, required super.title});

  static const assetName = 'assets/images/example_polish.jpg';

  final _processImage = Image.asset(
    assetName,
    width: 150,
    height: 200,
    fit: BoxFit.cover,
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          simpleColumn(
            assetName: assetName,
            sampleImage: _processImage,
            result: GoogleVisionImageBuilder.textDetection(
              googleVision: googleVision,
              imageProvider: _processImage.image,
              builder:
                  (
                    BuildContext context,
                    List<EntityAnnotation>? entityAnnotations,
                  ) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children:
                          entityAnnotations!
                              .map((entity) => Text(entity.description))
                              .toList(),
                    ),
                  ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "This is the ABOUT page.  Press to return to the MENU page",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
