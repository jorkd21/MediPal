import 'package:flutter/material.dart';
import 'package:medipal/objects/appointment.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:medipal/pages/language_constants.dart';

class AppointmentList extends StatefulWidget {
  final String? userUid;

  const AppointmentList({
    super.key,
    required this.userUid,
  });

  @override
  AppointmentListState createState() => AppointmentListState();
}

class AppointmentListState extends State<AppointmentList> {
  late Practitioner? _practitioner;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPractitioner();
  }

  void _fetchPractitioner() async {
    Practitioner? practitioner =
        await Practitioner.getPractitioner(widget.userUid!);
    practitioner!.appointments.sort((a, b) {
      return a.patient!.toLowerCase().compareTo(b.patient!.toLowerCase());
    });
    setState(() {
      _practitioner = practitioner;
    });
  }

  List<Appointment> _filterAppointments(List<Appointment> appointments) {
    if (_searchQuery.isEmpty) {
      return appointments;
    } else {
      return appointments
          .where((appointment) =>
              appointment.patient!.toLowerCase().contains(_searchQuery))
          .toList();
    }
  }

  Widget _buildAppointmentInfo(Appointment appointment) {
    return GestureDetector(
      onTap: () {
        /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PractitionerPage(practitioner: practitioner),
          ),
        ); */
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
                    translation(context).nameLabel + '${appointment.patient}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    translation(context).topic + ": ${appointment.topic}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    translation(context).time + ": ${appointment.time}",
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
          title: Text(translation(context).appointmentList),
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
                decoration: InputDecoration(
                  hintText: translation(context).searchByName,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
        body: _practitioner!.appointments.isNotEmpty
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
                    itemCount:
                        _filterAppointments(_practitioner!.appointments).length,
                    itemBuilder: (context, index) {
                      return _buildAppointmentInfo(_filterAppointments(
                          _practitioner!.appointments)[index]);
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
