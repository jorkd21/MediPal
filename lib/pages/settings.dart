import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/main.dart';
import 'package:medipal/pages/account_details.dart';
import 'package:medipal/pages/language_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  Language dropdownValue = Language('English', 'en');
  List<Language> languages = [
    Language('English', 'en'),
    Language('Español', 'es'),
    Language('Le Français', 'fr'),
    Language('हिन्दी', 'hi'),
    Language('العربية', 'ar'),
    Language('kiswahili', 'sw'),
    Language('isiZulu', 'zu'),
  ];

  _saveLanguage(Language language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', language.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          translation(context).settings,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(0, 3),
                blurRadius: 5,
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 73, 118, 207),
                Color.fromARGB(255, 191, 200, 255),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 0,
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              FractionallySizedBox(
                                widthFactor: 1.0,
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 539.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 25.0),
                                          height: 290.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6589e3),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Text(
                                                    translation(context)
                                                        .preferences,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 40.0),
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                title: Row(
                                                  children: [
                                                    Text(
                                                      translation(context)
                                                          .language,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: DropdownButton<
                                                          Language>(
                                                        isExpanded: true,
                                                        value: dropdownValue,
                                                        icon: const Icon(Icons
                                                            .arrow_downward),
                                                        iconSize: 24,
                                                        elevation: 16,
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .deepPurple),
                                                        underline: Container(
                                                          height: 2,
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                        ),
                                                        onChanged: (Language?
                                                            language) async {
                                                          if (language !=
                                                              null) {
                                                            Locale locale =
                                                                await setLocale(
                                                                    language
                                                                        .languageCode);
                                                            MyApp.setLocale(
                                                                context,
                                                                locale);
                                                            _saveLanguage(
                                                                language);
                                                            setState(() {
                                                              dropdownValue =
                                                                  language;
                                                            });
                                                          }
                                                        },
                                                        items: languages.map<
                                                            DropdownMenuItem<
                                                                Language>>(
                                                          (Language language) {
                                                            return DropdownMenuItem<
                                                                Language>(
                                                              value: language,
                                                              child: Text(
                                                                  language
                                                                      .name),
                                                            );
                                                          },
                                                        ).toList(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF7f97ed),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          35.0),
                                                ),
                                                child: ListTile(
                                                  trailing: Image.asset(
                                                      'assets/arrow.png'),
                                                  title: Text(
                                                    translation(context)
                                                        .account,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25.0,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    translation(context)
                                                        .emailPasswordChange,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    // Navigate to Account settings page
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AccountInfoPage(
                                                                userUid: FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF1F56DE),
                                            minimumSize:
                                                const Size(300.0, 50.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                          child: Text(
                                            //Logout
                                            translation(context).logout,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 30.0,
                                            ),
                                          ),
                                          onPressed: () async {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            Navigator.pushNamed(
                                                context, '/Login');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Language {
  final String name;
  final String languageCode;

  Language(this.name, this.languageCode);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Language &&
        other.name == name &&
        other.languageCode == languageCode;
  }

  @override
  int get hashCode => name.hashCode ^ languageCode.hashCode;
}
