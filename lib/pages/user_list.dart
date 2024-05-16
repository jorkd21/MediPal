import 'package:flutter/material.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:medipal/pages/dashboard.dart';
import 'package:medipal/pages/language_constants.dart';

class PractitionerList extends StatefulWidget {
  const PractitionerList({super.key});

  @override
  PractitionerListState createState() => PractitionerListState();
}

class PractitionerListState extends State<PractitionerList> {
  late List<Practitioner> _practitioners = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPractitioners();
  }

  void _fetchPractitioners() async {
    List<Practitioner>? practitioner = await Practitioner.getAllPractitioners();
    practitioner!.sort((a, b) {
      return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
    });
    setState(() {
      _practitioners = practitioner;
    });
  }

  List<Practitioner> _filterPractitioners(List<Practitioner> practitioners) {
    if (_searchQuery.isEmpty) {
      return practitioners;
    } else {
      return practitioners
          .where((practitioner) =>
              practitioner.name!.toLowerCase().contains(_searchQuery))
          .toList();
    }
  }

  Widget _buildPractitionerInfo(Practitioner practitioner) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(userUid: practitioner.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    translation(context).nameLabel + ': ${practitioner.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    translation(context).email + ": ${practitioner.email}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(translation(context).allPractitionersList),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 0),
                    hintText: translation(context).searchByName,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(143, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      body: _practitioners.isNotEmpty
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
              color: Colors.white,
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    kBottomNavigationBarHeight,
                child: ListView.builder(
                  itemCount: _filterPractitioners(_practitioners).length,
                  itemBuilder: (context, index) {
                    return _buildPractitionerInfo(
                        _filterPractitioners(_practitioners)[index]);
                  },
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
