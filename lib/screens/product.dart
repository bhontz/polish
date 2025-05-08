import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_vision_flutter/google_vision_flutter.dart';
import '../bloc/productscreens/product_bloc.dart';
import 'dart:io';
import 'homepage.dart';
import 'theme.dart';

final googleVision = GoogleVision().withAsset(
  'assets/keys/teacher-project-3f7c9-c14c33373554.json',
); // had LogLevel.all within parans

class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.polishImage});
  final File? polishImage;

  @override
  Widget build(BuildContext context) {
    final VisionAPIBloc visionBloc = BlocProvider.of<VisionAPIBloc>(context);
    String bc = '#696969';
    List<String> polishColors = [];

    Widget buildCard(String sHex) {
      return GestureDetector(
        onTap: () {
          bc = sHex;
        },
        child: Container(
          color: Color(int.parse(sHex.replaceFirst('#', 'ff'), radix: 16)),
          width: 40,
          height: 40,
        ),
      );
    }

    List<Widget> createColorChoices(List<String> sHex) {
      List<Widget> colorSamples = [];
      for (String s in sHex) {
        colorSamples.add(buildCard(s));
        colorSamples.add(SizedBox(width: 15));
      }
      return colorSamples;
    }

    Widget captureImageLabelText(List<EntityAnnotation>? entityAnnotations) {
      if (entityAnnotations != null) {
        var s = entityAnnotations[0].description;
        debugPrint(s.replaceAll('\n', ','));
      }
      return Container();
    }

    Widget captureImageColors(
      ImagePropertiesAnnotation? imagePropertiesAnnotations,
    ) {
      var counter = 0;
      if (imagePropertiesAnnotations != null) {
        polishColors = [];
        for (var d in imagePropertiesAnnotations.dominantColors.colors) {
          String? hex = '#';
          if (d.score > 0.09) {
            counter = counter += 1;
            hex += d.color.red.toInt().toRadixString(16).padLeft(2, '0');
            hex += d.color.green.toInt().toRadixString(16).padLeft(2, '0');
            hex += d.color.blue.toInt().toRadixString(16).padLeft(2, '0');
            debugPrint(hex);
            polishColors.add(hex);
          }
          if (counter == 5) {
            break;
          }
          debugPrint(polishColors.toString());
          bc = polishColors[0];
          visionBloc.add(ColorScan());
        }
      }
      return Container();
    }

    Widget conditionalPart() {
      return BlocBuilder<VisionAPIBloc, VisionAPIState>(
        builder: (context, state) {
          if (state is Loading) {
            return CircularProgressIndicator();
          } else if (state is ScannedColors) {
            return Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      color: Color(
                        int.parse(bc.replaceFirst('#', 'ff'), radix: 16),
                      ),
                      width: double.infinity,
                      height: 200,
                      // alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: 200,
                      width: 100,
                      child: Image.file(polishImage!, fit: BoxFit.contain),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: createColorChoices(polishColors),
                  // sTest,
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      );
    }

    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: Center(
        child: Column(
          children: <Widget>[
            GoogleVisionImageBuilder.imageProperties(
              googleVision: googleVision,
              imageProvider:
                  Image.file(polishImage!, fit: BoxFit.contain).image,
              builder:
                  (
                    BuildContext context,
                    ImagePropertiesAnnotation? imagePropertiesAnnotations,
                  ) => captureImageColors(imagePropertiesAnnotations),
            ),
            GoogleVisionImageBuilder.textDetection(
              googleVision: googleVision,
              imageProvider:
                  Image.file(polishImage!, fit: BoxFit.contain).image,
              builder:
                  (
                    BuildContext context,
                    List<EntityAnnotation>? entityAnnotations,
                  ) => captureImageLabelText(entityAnnotations),
            ),
            conditionalPart(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => HomePage()));
              },
              child: Text("This is the Products Page"),
            ),
          ],
        ),
      ),
    );
  }
}
