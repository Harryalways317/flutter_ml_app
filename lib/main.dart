import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'fruit_detector.dart';

// Global variable for storing the list of cameras available
List<CameraDescription> cameras = [];

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('CameraError: ${e.description}');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MLKit Vision',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(

          children: [
            MaterialButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(page: 'email',)));
            },child: Text("Detect Emails"),),
            MaterialButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(page: 'barcode',)));
            },child: Text("Detect Barcode"),),
            MaterialButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => FruitDetector()));
            },child: Text("Detect Fruits"),),
          ],
        ),
      ),
    );
  }
}
