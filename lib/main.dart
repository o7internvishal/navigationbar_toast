import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:permission_haldelr/permission_haldelr.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PermissionStatus? _permissionStatus;
  File? imageFile = null;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onLayoutDone);
    // !
  }

  void onLayoutDone(Duration timeStamp) async {
    _permissionStatus = await Permission.camera.status;
    setState(() {});
  }

  void _showChoiceDialog(BuildContext context) async {
    // if (imageFile != null) {
    //   showMessage();
    // } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      showMessage();
                      _openGallery(context);
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.browse_gallery_sharp,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _askCameraPermission();

                      _openCamera(context);
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  // }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'This is toast notification',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.amber);
  }

  void showMessage() {
    Fluttertoast.showToast(
        msg: 'upload your picture',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.amber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Toast"),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Card(
                child: (imageFile == null)
                    ? Text("Choose Image")
                    : Image.file(imageFile!),
              ),
              MaterialButton(
                textColor: Colors.white,
                color: Colors.pink,
                onPressed: () async {
                  showToast();
                  final text = "This is snakbar";
                  final snackbar = SnackBar(
                      content: Text(text),
                      action: SnackBarAction(
                        label: 'dismiss',
                        onPressed: () {},
                      ));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  _showChoiceDialog(context);
                },
                child: Text("Select Image"),
              ),
              MaterialButton(
                textColor: Colors.white,
                color: Colors.pink,
                onPressed: () async {
                  setState(() {
                    imageFile = null;
                  });
                },
                child: Text("Remove Image"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) {
    ImagePicker()
        .pickImage(
          source: ImageSource.gallery,
        )
        .then((value) => imageFile = File(value!.path));
    setState(() {
      print("image file $imageFile");
    });
    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) {
    ImagePicker()
        .pickImage(
          source: ImageSource.camera,
        )
        .then((value) => imageFile = File(value!.path));
    setState(() {
      // imageFile = pickedFile as File;
    });
    Navigator.pop(context);
  }

  void _askCameraPermission() async {
    // cek permission granted atau denied
    if (await Permission.camera.request().isGranted) {
      
      _permissionStatus = await Permission.camera.status;
     
      setState(() {});
    }
  }
  
}
