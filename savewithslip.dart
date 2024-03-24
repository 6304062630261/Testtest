import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class SlipOCR extends StatefulWidget {
  const SlipOCR({Key? key}) : super(key: key);

  @override
  State<SlipOCR> createState() => _SlipOCRState();
}
class _SlipOCRState extends State<SlipOCR> {
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";
  double total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Testtest "),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning) const CircularProgressIndicator(),
                if (!textScanning && imageFile == null)
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.grey[300]!,
                  ),
                if (imageFile != null) Image.file(File(imageFile!.path)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.grey[400],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image,
                                size: 30,
                              ),
                              Text(
                                "Gallery",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Remove the camera button from here
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Text(
                      scannedText,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      total.toString(),
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void filterScannedText(String text) {
    // Create a regex pattern to find numbers with 2 decimal places
    RegExp regex = RegExp(r'\b\d+\.\d{2}\b');

    // Find text that matches the condition in the regex and extract the found text
    Iterable<Match> matches = regex.allMatches(text);
    List<String> filteredTexts =
        matches.map((match) => match.group(0)!).toList();

    // Update the scannedText to only contain filtered text
    setState(() {
      scannedText = filteredTexts.join('\n');
    });
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    total = 0;

    // Loop through each block of text detected
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        // Replace commas with empty strings to remove them
        String lineText = line.text.replaceAll(",", "");
        // Find text that matches the condition in the regex and extract the found text
        RegExp regex = RegExp(r'\b\d+\.\d{2}\b');
        Iterable<Match> matches = regex.allMatches(lineText);
        List<String> filteredTexts =
            matches.map((match) => match.group(0)!).toList();
        // Append the filtered text to the scannedText
        if (filteredTexts.length > 0) {
          scannedText += filteredTexts.join('\n') + "\n";
        }
        // const num = scannedText.split()
      }
    }
    List<String> valueString = scannedText.split('\n');
    for (String value in valueString) {
      if (value.trim().isNotEmpty) {
        try {
          double amount = double.parse(value.trim());
          total += amount;
          print('Total: $total');
        } catch (e) {
          print('Error parsing value: $value');
        }
      }
    }

    textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
