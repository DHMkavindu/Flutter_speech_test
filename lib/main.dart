import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  SpeechRecognition _speechRecognition;
  bool _isAvailable=false;
  bool _isListening=false;

  String resultTest="";

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer(){
    _speechRecognition=SpeechRecognition();

    _speechRecognition.setAvailabilityHandler((bool result) => setState(() => _isAvailable = result),);

    _speechRecognition.setRecognitionStartedHandler(() => setState(() => _isListening =true),);
    
    _speechRecognition.setRecognitionResultHandler((String speech) => setState(()=> resultTest=speech),);

    _speechRecognition.setRecognitionCompleteHandler(() => setState(() => _isListening =false),);

    _speechRecognition.activate().then((result) => setState(() => _isAvailable = result),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.cancel),
                  mini: true,
                  backgroundColor: Colors.deepOrange,
                  onPressed: (){
                    if(_isListening)
                      _speechRecognition.cancel().then((result) => setState((){
                        _isListening=result;
                        resultTest="";
                      }),);
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  backgroundColor: Colors.pink,
                  onPressed: (){
                    if(_isAvailable && ! _isListening)
                      _speechRecognition
                        .listen(locale: "en_US")
                        .then((result) => print('$result'));
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.stop),
                  mini: true,
                  backgroundColor: Colors.deepPurple,
                  onPressed: (){
                    if(_isListening)
                      _speechRecognition.stop().then((result) => setState(() => _isListening = result),);
                  },
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.6,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: Text(resultTest),
            )
          ],
        ),
      ),
    );
  }
}




