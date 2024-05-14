import 'package:flutter/material.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:medipal/pages/user_data.dart';

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
    List<Practitioner> practitioner = await Practitioner.getAllPractitioners();
    practitioner.sort((a, b) {
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
            builder: (context) => PractitionerPage(practitioner: practitioner),
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
                  const SizedBox(height: 4),
                  Text(
                    'Name: ${practitioner.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Email: ${practitioner.email}",
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('All Practitioner List'),
          flexibleSpace: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromARGB(255, 192, 212, 248),
                  Color.fromARGB(255, 214, 228, 255),
                ],
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search by name...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
        body: _practitioners.isNotEmpty
            ? Container(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(
                          255, 151, 183, 247), // Light blue at the bottom
                      Color.fromARGB(255, 192, 212, 248), // White at top
                    ],
                  ),
                ),
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
      ),
    );
  }
}
