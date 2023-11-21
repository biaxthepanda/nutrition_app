import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class Calendar extends StatelessWidget {
  Calendar({super.key});

  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column( 
        children: [
        Text("data"),

        Container(
          child: TableCalendar(
            locale: "en_US",
            rowHeight: 40,
            headerStyle: 
              HeaderStyle(formatButtonVisible: false,titleCentered: true),
            availableGestures: AvailableGestures.all,
            focusedDay: today,
            firstDay: DateTime.utc(2010,10,16),
            lastDay: DateTime.utc(2030,3,14)
            ),
        ),

        ],
      ),
    );
  }
}

