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
  bool _isButtonDisabled = true;
  int? _currentIndex;

  @override
  Widget build(BuildContext context) {
    Widget appointmentWidget =
        _appointmentSelect(); // Create a widget variable for _appointmentSelect()

    return Scaffold(
      appBar: AppBar(
        title: Text("Date Selected: ${today.toString().split(" ")[0]}"),
        flexibleSpace: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 192, 212, 248), // light blue at bottom
                Color.fromARGB(255, 214, 228, 255), // White at top
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                appointmentWidget, // Use the variable instead of method call because of 'Methods can't be invoked in constant expressions'
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Select a Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isWeekend
              ? SliverToBoxAdapter(
                  //Message when no appointment times
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      //message style
                      'No Times Available For This Day',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                            _timeselected = true;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color:
                                _currentIndex == index //color of buton pressed
                                    ? const Color.fromARGB(197, 29, 53, 161)
                                    : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            //times begin at 9 and increments by one for each button being created
                            '${index + 9}:00',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  _currentIndex == index ? Colors.white : null,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: 10, //number of buttons of times created
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, //amount of buttons per row
                      childAspectRatio: 1.5), //size ratio of the buttons
                ),
          const SliverToBoxAdapter(
              //patient select

              ),
          SliverToBoxAdapter(
            //the submit button
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 180),
              child: SizedBox(
                height: 40,
                width: 100,
                child: TextButton(
                  onPressed: //disables button if time is not picked or the day is not available
                      _isButtonDisabled && _timeselected ? () => {} : null,
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(197, 29, 53, 161), //button color
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentSelect() {
    return SafeArea(
      child: TableCalendar(
        locale: "en_US", //laguage for the calendar
        rowHeight: 48,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        selectedDayPredicate: (daySelected) => isSameDay(daySelected, today),
        focusedDay: today,
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2040, 1, 1),
        onDaySelected: (daySelected, focusedDay) {
          setState(() {
            today = daySelected;

            //checks if selected date is a weekend
            //can change to other days that the clinic is closed
            if (today.weekday == 6 || today.weekday == 7) {
              _isWeekend = true;
              _timeselected = false;
              _currentIndex = null;
              _isButtonDisabled = false;
            } else {
              _isWeekend = false;
              _isButtonDisabled = true;
            }
          });
        },
      ),
    );
  }
}
