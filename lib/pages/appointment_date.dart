import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentDate extends StatefulWidget {
  const AppointmentDate({super.key});

  @override
  State<AppointmentDate> createState() => _AppointmentDateState();
}

class _AppointmentDateState extends State<AppointmentDate> {
  DateTime today = DateTime.now();
  bool _isWeekend = false;
  bool _timeselected = false;
  int? _currentIndex;

  void _selectedDay(DateTime daySelected, DateTime focusedDay) {
    setState(() {
      today = daySelected;

      //checks if it is a weekend
      //can change to another value on days the clinic is close
      if (today.weekday == 6 || today.weekday == 7) {
        _isWeekend = true;
        _timeselected = false;
        _currentIndex = null;
      } else {
        _isWeekend = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Selected Day = ${today.toString().split(" ")[0]}")),
      body: _appointmentSelect(),
    );
  }

  Widget _appointmentSelect() {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          //gradient of background
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 151, 183, 247), // bottom color
              Color.fromARGB(255, 192, 212, 248), // top color
            ],
          ),
        ),
        child: TableCalendar(
          locale: "en_US", //calendar language
          rowHeight: 48,
          headerStyle: const HeaderStyle(
              //style of month and year header
              formatButtonVisible: false,
              titleCentered: true),
          selectedDayPredicate: (daySelected) => isSameDay(daySelected, today),
          focusedDay: today,
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2040, 1, 1),
          onDaySelected: _selectedDay,
        ),
      ),
    );
  }
}
