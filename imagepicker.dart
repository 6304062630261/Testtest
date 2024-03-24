import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  PickedFile? _image;

  Future<void> _pickImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Picker')),
      body: Center(
        child: Column(
          children: <Widget>[
            if (_image != null) Image.file(File(_image!.path)),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
          ],
        ),
      ),
    );
  }
}
