import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gdsc_solution/screen/camera3/realtime/live_camera.dart';
import 'package:gdsc_solution/screen/camera3/static image/static.dart';
List<CameraDescription>? cameras;

Future<void> main() async {
  // initialize the cameras when the app starts
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  // running the app
  runApp(
    MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    )
  );
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Object Detector App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: aboutDialog,
          ),
        ],
      ),
      body: Container(
        child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                minWidth: 170,
                child: RaisedButton(
                  child: Text("Detect in Image"),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => StaticImage(),
                      ),
                    );
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 160,
                child: RaisedButton(
                  child: Text("Real Time Detection"),
                  onPressed:() {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => LiveFeed(cameras!),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  aboutDialog(){
    showAboutDialog(
      context: context,
      applicationName: "trash Detector App",
      applicationLegalese: "Jeong Hyeong Lee",
      applicationVersion: "1.0",
      children: <Widget>[
        Text("trash detection app"),
      ],
    );
  }

}