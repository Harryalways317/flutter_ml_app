import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';




class BarcodeScreen extends StatefulWidget {
  final String imagePath;

  const BarcodeScreen({required this.imagePath});

  @override
  _BarcodeScreenState createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  late final String _imagePath;
  late final TextDetector _textDetector;
  final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  Size? _imageSize;
  List<Barcode> _elements = [];
  List<Barcode> barcodeElements = [];

  List<String>? _listEmailStrings;

  // Fetching the image size from the image file
  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  // To detect the email addresses present in an image

  void _recognizeBarcodes() async {
    _getImageSize(File(_imagePath));

    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(_imagePath);
    // Retrieving the RecognisedText from the InputImage
    List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

    // Finding and storing the text String(s) and the TextElement(s)
    for (Barcode barcode in barcodes) {
      _elements.add(barcode);

      print(barcode.value.rawValue.toString()+barcode.type.name.toString());
    }

    setState(() {
    });
  }

  @override
  void initState() {
    _imagePath = widget.imagePath;
    // Initializing the text detector

    _recognizeBarcodes();
    super.initState();
  }

  @override
  void dispose() {
    // Disposing the text detector when not used anymore
    _textDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Details"),
      ),
      body: _imageSize != null
          ? Stack(
        children: [
          Container(
            width: double.maxFinite,
            color: Colors.black,
            child: CustomPaint(
              foregroundPainter: BarcodeDetectorPainter(
                _imageSize!,
                _elements,
              ),
              child: AspectRatio(
                aspectRatio: _imageSize!.aspectRatio,
                child: Image.file(
                  File(_imagePath),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Identified emails",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      child: SingleChildScrollView(
                        child: _listEmailStrings != null
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: _listEmailStrings!.length,
                          itemBuilder: (context, index) =>
                              Text(_listEmailStrings![index]),
                        )
                            : Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
          : Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}



class BarcodeDetectorPainter extends CustomPainter {
  BarcodeDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<Barcode> elements;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(Barcode container) {
      return Rect.fromLTRB(
        container.value.boundingBox?.left ?? 0 * scaleX,
        container.value.boundingBox?.top??0 * scaleY,
        container.value.boundingBox?.right??0 * scaleX,
        container.value.boundingBox?.bottom??0 * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (Barcode element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }
  }

  @override
  bool shouldRepaint(BarcodeDetectorPainter oldDelegate) {
    return true;
  }
}