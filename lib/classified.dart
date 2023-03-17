
// ignore_for_file: depend_on_referenced_packages, unused_field

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import "package:image/image.dart" as img;


import 'package:image_picker1/classifier.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'classifier_quant.dart';


class RetinaClassified extends StatefulWidget {
  const RetinaClassified({super.key});

  @override
  State<RetinaClassified> createState() => _RetinaClassifiedState();
}

class _RetinaClassifiedState extends State<RetinaClassified> {
  
  late Classifier _classifier;

  var logger = Logger();

  final picker = ImagePicker();



  img.Image? fox;

  Category? category;

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text('Retinal Image Classification',
            style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Center(
             child: Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height / 2),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    //child: _imageWidget,
                  ),
          ),
          const SizedBox(
            height: 36,
          ),
          Text(
            category != null ? category!.label : '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            category != null
                ? 'Confidence: ${category!.score.toStringAsFixed(3)}'
                : '',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      )
    );
  }
}
