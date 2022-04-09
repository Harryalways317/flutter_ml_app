import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class FruitDetector extends StatefulWidget {
  @override
  _FruitDetectorState createState() => _FruitDetectorState();
}

class _FruitDetectorState extends State<FruitDetector> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output ?? [];
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);

    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.yellow,
              Colors.pinkAccent
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.004, 1],
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                'Fruits Classifier',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              Text(
                'Tensorflow Lite Model',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: _loading
                            ? Container(
                          width: 300,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/fruits.jpg',
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: pickImage,
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width -
                                            180,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 17,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF56ab2f),
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "Caputure a Photo",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    GestureDetector(
                                      onTap: pickGalleryImage,
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width -
                                            180,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 17,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF56ab2f),
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "Gallery Photo's ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                          ),
                        )
                            : Container(
                          child: Column(
                            children: [
                              Container(
                                height: 300,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(_image),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              _output != null
                                  ? Text(
                                'Predictions is, ${_output[0]['label']}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20),
                              )
                                  : Container(),
                              SizedBox(
                                height: 4,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: pickImage,
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width -
                                            180,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 17,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF56ab2f),
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "Capture a Photo",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    GestureDetector(
                                      onTap: pickGalleryImage,
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width -
                                            180,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 17,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF56ab2f),
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "Gallery Photo's ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}