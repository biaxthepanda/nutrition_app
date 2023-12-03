import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:nutrition_app/model/meal.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nutrition_app/model/meal_manager.dart';


class CalendarWidget extends StatefulWidget {
  CalendarWidget({super.key});

 


  @override
  State<CalendarWidget> createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  void _onDaySelected(DateTime day,DateTime focusedDay)
  {
    setState(() {
      selectedDay = DateTime(day.year,day.month,day.day); 
      _selectedMeal.value = _getMealForDay(selectedDay);
    });
  }

  //Meal List
  //Map<DateTime,List<Meal>> mealHistory = {};
  final TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Meal>> _selectedMeal;
  @override
  void initState()
  {
    super.initState();
    _selectedMeal = ValueNotifier(_getMealForDay(selectedDay));
  }

  List<Meal> _getMealForDay(DateTime day) 
  {
    return mealHistory[day] ??  [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          showDialog(context: context, builder: (context){
            return AlertDialog(
              scrollable: true,
              title: Text("Event Name"),
              content: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: _eventController,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: ()
                  {
                    mealHistory.addAll({selectedDay: [Meal(name: _eventController.text,protein:1,cabs: 1,calory: 1,fats: 1)]});
                    Navigator.of(context).pop();
                    _selectedMeal.value = _getMealForDay(selectedDay);
                  }, 
                  child: const Text("submit")),
              ],
            );
            });
        },
        child: const Icon(Icons.add),
        ),
      body: Column( 
        children: [
        const Text("data"),

        Container(
          child: TableCalendar(
            locale: "en_US",
            rowHeight: 40,
            headerStyle: 
              const HeaderStyle(formatButtonVisible: false,titleCentered: true),
            availableGestures: AvailableGestures.all,
            eventLoader: _getMealForDay,
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            focusedDay: today,
            firstDay: DateTime.utc(2010,10,16),
            lastDay: DateTime.utc(2030,3,14),
            onDaySelected: _onDaySelected,
            ),
          
        ),
        SizedBox(height: 50,),
        Expanded(
          child: ValueListenableBuilder(valueListenable: _selectedMeal, builder: (context,value,_){
            return ListView(
              children: [
                    for(int i = 0; i < value.length; i++)
                      MealCard2(meal: value[i]),
                  ],
            );
          }),
        )
        ],
      ),
    );
  }
  
  
}

