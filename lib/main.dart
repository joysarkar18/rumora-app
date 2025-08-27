import 'package:campus_crush_app/app.dart';
import 'package:campus_crush_app/firebase_options.dart';
import 'package:campus_crush_app/services/typesence_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await TypeSenseInstance().initialize();
  runApp(const MyApp());
}
