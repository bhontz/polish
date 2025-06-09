import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_vision_flutter/google_vision_flutter.dart';
import '../bloc/productscreens/product_bloc.dart';
import '../services/googleapi_service.dart';
import 'dart:io';
import 'homepage.dart';
import 'theme.dart';

final googleVision = GoogleVision().withAsset(
  'assets/keys/teacher-project-3f7c9-c14c33373554.json',
); // had LogLevel.all within parans

class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.polishImage});
  final File? polishImage;

  Future<String> imageToBase64() async {
    File imageFile = File(polishImage!.path);
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    final VisionAPIBloc visionBloc = BlocProvider.of<VisionAPIBloc>(context);
    String bc = '#696969';
    List<String> polishColors = [];
    String brandName = "NOT*DETECTED";

    Widget buildCard(String sHex) {
      return GestureDetector(
        onTap: () {
          bc = sHex;
          visionBloc.add(ChangeBC());
          // bc = sHex;
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

    Widget googleVisionApi() {
      RecognizeProvider rec = RecognizeProvider();
      imageToBase64().then((String result) {
        rec.imageText(result).then((String b) {
          debugPrint("from RecognizeProvider method imageText: $b");
          brandName = b;
          rec.imageColors(result).then((List<String> colorList) {
            debugPrint("from RecognizeProvider method imageColors: $colorList");
            polishColors.addAll(colorList);
            visionBloc.add(ImageCapture());
          });
        });
      });

      return Container();
    }

    Widget conditionalPart() {
      return BlocBuilder<VisionAPIBloc, VisionAPIState>(
        builder: (context, state) {
          if (state is Loading) {
            return CircularProgressIndicator();
          } else if (state is CapturedImage || state is ChangingBC) {
            return Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      color:
                          (state is ChangingBC)
                              ? Color(
                                int.parse(
                                  bc.replaceFirst('#', 'ff'),
                                  radix: 16,
                                ),
                              )
                              : Color(0xff696969),
                      width: double.infinity,
                      height: 200,
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
                ),
                const SizedBox(height: 20),
                Text(brandName, style: TextStyle(fontSize: 24)),
              ],
            ); // Column
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
            googleVisionApi(),
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
