
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import "package:image/image.dart" as img;


import 'package:image_picker1/classifier.dart';
import 'package:image_picker1/classifier_quant.dart';
import 'package:image_picker1/classified.dart';

import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedImagePath = '';
  late Classifier _classifier;

  var logger = Logger();

  File? _image;
  final picker = ImagePicker();
  Image? _imageWidget;
  img.Image? fox;

  Category? category;

@override
 void initState() {
    super.initState();
    _classifier = ClassifierQuant();
  }

  void _predict() async {
    img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    var pred = _classifier.predict(imageInput);

    setState(() {
      category = pred;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedImagePath == ''
                ? Image.asset('assets/image_placeholder.png', height: 200, width: 200, fit: BoxFit.fill,)
                : Image.file(File(selectedImagePath), height: 200, width: 200, fit: BoxFit.fill,),
            const Text(
              'Select Image',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 14, color: Colors.white))),
                onPressed: () async {
                  selectImage();
                  setState(() {});
                },
                child: const Text('Select')),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future selectImage() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Expanded(child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Expanded(child: SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text(
                      'Select Image From !',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: selectImageFromGallery,

                          /*async {
                            selectedImagePath = await selectImageFromGallery();
                            if (selectedImagePath != '') {
                              setState(() {
                                _predict();
                              });
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const RetinaClassified())
                              );
                              
                            } else {
                              ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
                                content: Text("No Image Selected !"),
                              ));
                            }
                          }*/
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/gallery.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    const Text('Gallery'),
                                  ],
                                ),
                              )
                            ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            getimage();
                            /*selectedImagePath = await selectImageFromCamera();

                            if (selectedImagePath != '') {
                              setState(() {
                                _predict();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RetinaClassified())
                                );
                              });

                              
                            } else {
                              ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
                                content: Text("No Image Captured !"),
                              ));
                            }*/
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/camera.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    const Text('Camera'),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
            )
          )
          );
        });
  }

   selectImageFromGallery() async {
    final file = await ImagePicker()
        .pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(file!.path);
      _imageWidget = Image.file(_image!);
      _predict();
    });

    /*if (file != null) {
      return file.path;
    } else {
      return '';
    }*/
  }

  //
  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      _predict();
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RetinaClassified())
      );
      return file.path;
    } else {
      return '';
    }
    
  }
  Future getimage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile!.path);
      _imageWidget = Image.file(_image!);
      _predict();
    });
  }

}

