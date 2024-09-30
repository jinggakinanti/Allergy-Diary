// ignore_for_file: avoid_print, use_build_context_synchronously, file_names

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/components/ResultScreen.dart';
import 'package:project/services/allergenService.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with WidgetsBindingObserver {
  bool isPermissionGranted = false;
  late final Future<void> future;
  CameraController? cameraController;
  final textRecognizer = TextRecognizer();
  final AllergenService allergenService = AllergenService();
  List<Allergen> allergens = [];
  List<String> userAllergies = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    future = requestCameraPermission();
    fetchAllergens();
    fetchUserAllergies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  Future<void> fetchAllergens() async {
    allergens = await allergenService.getAllergens();
  }

  Future<void> fetchUserAllergies() async {
    String userId = 'UY2VuO3XehakiTC8WacnJG2BS1x2';
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      userAllergies = List<String>.from(userDoc['allergies']);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        cameraController != null &&
        cameraController!.value.isInitialized) {
      startCamera();
    }
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      isPermissionGranted = status == PermissionStatus.granted;
    });
  }

  void initCameraController(List<CameraDescription> cameras) {
    if (cameraController != null) {
      return;
    }
    CameraDescription? camera;
    for (var current in cameras) {
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }
    if (camera != null) {
      cameraSelected(camera);
    }
  }

  Future<void> cameraSelected(CameraDescription camera) async {
    cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);
    await cameraController?.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void startCamera() {
    if (cameraController != null) {
      cameraSelected(cameraController!.description);
    }
  }

  void stopCamera() {
    if (cameraController != null) {
      cameraController?.dispose();
    }
  }

  Future<void> scanImage() async {
    if (cameraController == null) {
      return;
    }
    final navigator = Navigator.of(context);
    try {
      final pictureFile = await cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);

      final detectedAllergens = checkAllergens(recognizedText.text);

      await navigator.push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            text: recognizedText.text,
            detectedAllergens: detectedAllergens,
            userAllergies: userAllergies,
          ),
        ),
      );
    } catch (e) {
      _showAlertDialog();
    }
  }

  List<String> checkAllergens(String text) {
    List<String> detectedAllergens = [];
    for (var allergen in allergens) {
      if (text.toLowerCase().contains(allergen.name.toLowerCase())) {
        detectedAllergens.add(allergen.name);
      }
      for (var trigger in allergen.triggers) {
        if (text.toLowerCase().contains(trigger.toLowerCase())) {
          detectedAllergens.add(allergen.name);
        }
      }
    }
    print('Detected Allergens: $detectedAllergens');
    return detectedAllergens;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return Stack(
            children: [
              if (isPermissionGranted)
                FutureBuilder<List<CameraDescription>>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        initCameraController(snapshot.data!);
                        return Center(
                          child: cameraController != null &&
                                  cameraController!.value.isInitialized
                              ? CameraPreview(cameraController!)
                              : const LinearProgressIndicator(),
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    }),
              Scaffold(
                backgroundColor:
                    isPermissionGranted ? Colors.transparent : null,
                body: isPermissionGranted
                    ? Column(
                        children: [
                          Expanded(child: Container()),
                          Container(
                            padding: const EdgeInsets.only(bottom: 70),
                            child: GestureDetector(
                              onTap: scanImage,
                              child: Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(143, 173, 222, 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Scan Text',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 24.0, right: 24.0),
                          child: const Text(
                            'Camera Permission Denied',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Outfit'),
                          ),
                        ),
                      ),
              ),
            ],
          );
        });
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontFamily: 'Outfit'),
          ),
          content: const Text('An error occurred when scanning text.',
              style: TextStyle(fontFamily: 'Outfit')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(fontFamily: 'Outfit')),
            ),
          ],
        );
      },
    );
  }
}
