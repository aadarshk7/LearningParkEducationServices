import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/src/painting/text_style.dart" as ts;
import 'package:flutter_firebase_recaptcha/firebase_recaptcha_verifier_modal.dart';
import 'package:learningparkeducation/screens/splash_screen.dart';

// Code to connect with firebase databases
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
            measurementId: "G-FREWCBF7Y1"));
  }
  ;

// await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   const firebaseConfig = {
//     'apiKey': "AIzaSyDx24fU-veTw_QttLg5mzgAJiDrYXv1EOM",
//     'authDomain': "loginapp-87017.firebaseapp.com",
//     'projectId': "loginapp-87017",
//     'storageBucket': "loginapp-87017.appspot.com",
//     'messagingSenderId': "939288879280",
//     'appId': "1:939288879280:web:939288879280",
//   };

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
//   api key here
      appId: "learningparkeducation",
//  app id here
      messagingSenderId: "45063901374",
// messagingSenderId here
      projectId: "learningparkeducation", // project id here
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
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
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

// // Update the parameter name in the MaterialApp widget
// return MaterialApp(
//   debugShowCheckedModeBanner: false,
//   home: StreamBuilder<User?>(
//     stream: FirebaseAuth.instance.authStateChanges(),
//     builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
//       if (snapshot.hasError)
//       {
//         return Text(snapshot.error.toString());
//       }
//       if (snapshot.connectionState == ConnectionState.active) {
//         if (snapshot.data == null) {
//           return Googlescreen();
//         } else {
//           return LoginPage(
//               userName: FirebaseAuth.instance.currentUser!
//                   .displayName!); // Corrected parameter name
//         }
//       }
//       return Center(child: CircularProgressIndicator());
//     },
//   ),
// );

// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context){
//     final authService = Provider.of<AuthService>(context);
//     return StreamBuilder<User?>(
//       stream: authService.user,
//       builder: (_, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           final User? user = snapshot.data;
//           return user == null ? LoginPage() : HomePage();
//         } else {
//           return Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//       },
//     );
//   }
// }
