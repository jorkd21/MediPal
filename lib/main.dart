import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medipal/pages/home.dart';
import 'package:medipal/pages/user_list.dart';
import 'package:medipal/pages/user_patients.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/pages/appointment_page.dart';
import 'package:medipal/pages/dashboard.dart';
import 'package:medipal/pages/signup.dart';
import 'package:medipal/pages/login.dart';
import 'package:medipal/pages/patient_list.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:medipal/pages/patient_form.dart';
import 'package:medipal/pages/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final bool _testing = false;
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation Development Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/',
      routes: {
        '/': (context) => widget._testing ?  const TestingPage() : const LoginPage(),
        '/Login': (context) => const LoginPage(),
        '/SignUp': (context) => const SignUpPage(),
        '/PatientForm': (context) => PatientForm(patient: Patient()),
        '/PatientList': (context) => const PatientList(),
        '/AppointmentPage': (context) =>
            AppointmentPage(userUid: FirebaseAuth.instance.currentUser!.uid),
        '/Dashboard': (context) =>
            Dashboard(userUid: FirebaseAuth.instance.currentUser!.uid),
        '/UserPatients': (context) => PractitionerPatients(
            userUid: FirebaseAuth.instance.currentUser!.uid),
        '/Settings': (context) => const SettingsPage(),
        '/Home': (context) => const HomePage(),
        '/UserList': (context) => const PractitionerList(),
      },
      locale: _locale,
    );
  }
}

class TestingPage extends StatelessWidget {
  const TestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              if (FirebaseAuth.instance.currentUser != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute<ProfileScreen>(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              }
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ButtonWidget('Login', '/Login'),
          ButtonWidget('Sign Up', '/SignUp'),
          ButtonWidget('PatientForm', '/PatientForm'),
          ButtonWidget('PatientList', '/PatientList'),
          ButtonWidget('Appointmentpage', '/AppointmentPage'),
          ButtonWidget('Dashboard', '/Dashboard'),
          ButtonWidget('UserPatients', '/UserPatients'),
          ButtonWidget('ChatList', '/ChatList'),
          ButtonWidget('Settings', '/Settings'),
          ButtonWidget('Home', '/Home'),
          ButtonWidget('UserList', '/UserList'),
          ButtonWidget('LanguageRegionSelect', '/LanguageRegionSelect'),
        ],
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String buttonText;
  final String routeName;

  const ButtonWidget(this.buttonText, this.routeName, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Text(buttonText),
    );
  }
}
