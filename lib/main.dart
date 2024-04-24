import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Resizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageResizer(),
    );
  }
}

class ImageResizer extends StatefulWidget {
  @override
  _ImageResizerState createState() => _ImageResizerState();
}

class _ImageResizerState extends State<ImageResizer> {
  late File _image;
  final picker = ImagePicker();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Resizer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.file(_image),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _widthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Width'),
            ),
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Height'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resizeImage,
              child: const Text('Resize Image'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _resizeImage() {
    int width = int.tryParse(_widthController.text) ?? 100;
    int height = int.tryParse(_heightController.text) ?? 100;

    img.Image? image = img.decodeImage(_image.readAsBytesSync());
    img.Image resizedImage = img.copyResize(image!, width: width, height: height);

    setState(() {
      _image = File('resized_image.jpg')..writeAsBytesSync(img.encodeJpg(resizedImage));
    });
  }
}
