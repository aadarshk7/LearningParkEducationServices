import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_recaptcha/firebase_recaptcha_verifier_modal.dart';
import 'package:learningparkeducation/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import '../chatbot/shared_preferences.dart' as sp;
import '../chatbot/chat_screen.dart';
import '../chatbot/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCqDgbG5Nau5-8QhmxshXGcZ2R8HQZ-C00",
        authDomain: "learningparkeducation.firebaseapp.com",
        projectId: "learningparkeducation",
        storageBucket: "learningparkeducation.appspot.com",
        messagingSenderId: "939288879280",
        appId: "1:45063901374:web:45063901374",
        measurementId: "G-FREWCBF7Y1",
      ),
    );
  }

  const firebaseConfig = {
    'apiKey': "AIzaSyCqDgbG5Nau5-8QhmxshXGcZ2R8HQZ-C00",
    'authDomain': "learningparkeducation.firebaseapp.com",
    'projectId': "learningparkeducation",
    'storageBucket': "learningparkeducation.appspot.com",
    'messagingSenderId': "939288879280",
    'appId': "1:45063901374:web:45063901374",
  };

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCqDgbG5Nau5-8QhmxshXGcZ2R8HQZ-C00",
      appId: "learningparkeducation",
      messagingSenderId: "45063901374",
      projectId: "learningparkeducation",
    ),
  );

  FirebaseRecaptchaVerifierModal(
    firebaseConfig: firebaseConfig,
    onVerify: (token) => print('token: ' + token),
    onLoad: () => print('onLoad'),
    onError: () => print('onError'),
    onFullChallenge: () => print('onFullChallenge'),
    attemptInvisibleVerification: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              // Implement theme switching logic
            },
          ),
        ],
      ),
      body: const Text("Firebase successfully connected"),
    );
  }
}
