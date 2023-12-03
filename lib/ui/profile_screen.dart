import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nutrition_app/model/meal.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:intl/intl.dart';
import 'package:nutrition_app/model/meal_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  DateTime today = DateTime.now();
  DateTime todaysDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  
  final TextEditingController mealNameEC = TextEditingController();
  final TextEditingController proteinEC= TextEditingController();
  final TextEditingController cabsEC = TextEditingController();
  final TextEditingController calsEC = TextEditingController();
  final TextEditingController fatsEC = TextEditingController();
  List<Meal>? todaysMeals;
  List<double> todaysNutritions = [0,0,0,0];
  double todaysCalory = 0;
  double todaysPro = 0;
  double todaysCab = 0;
  double todaysFat = 0;
  //0 calory, 1 protein, 2 fat, 3 cab

  Future<Map<String, dynamic>> fetchFoodNutrition(String foodName) async {
    final response = await http.get(Uri.parse('https://localhost:7144/api/nutrition/food/$foodName'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load nutrition data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    todaysMeals = getTodaysMeals(todaysDate);
    final todayDateWithHours = DateTime.now();
    setTodaysNutritions(todaysMeals, todaysNutritions);
    todaysCalory = todaysNutritions[0];
    todaysPro = todaysNutritions[1];
    todaysCab = todaysNutritions[2];
    todaysFat = todaysNutritions[3];

    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      
      body: Stack(
        children: <Widget>[
          //TOP CURVED PART
          Positioned(
            top: 0,
            height: height * 0.40,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: const Radius.circular(40)
                ),
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              padding: const EdgeInsets.only(left:32,right:32,top: 10,bottom: 10,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Hello User & Date
                  ListTile(
                    title: Text(
                      "${DateFormat("EEEE").format(todayDateWithHours)}, ${DateFormat("d MMMM").format(todayDateWithHours)}",
                      ),
                    subtitle: Text("Hello, Ikbal"),
                    //trailing: , Profile Picture
                  ),
                  //PROGRESSES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                       // RADIAL PROGRESS

                       
                      _RadialProgress(
                        width: width * 0.25,
                        height: height * 0.25,
                        progress:  todaysCalory / 2500,
                        calLeft: 2500 - todaysCalory,
                      ),
                      //NUTRITION PROGRESS
                      Column(
                        children: <Widget>[

                          _NutritionProgress(
                            nutrition: "Protein",
                            leftAmount: 120 - todaysPro,
                            progress: todaysPro/120,
                            progressColor: Colors.green.shade400,
                            width: width * 0.4,
                            height: height * 0.015,
                          ),

                          _NutritionProgress(
                            nutrition: "Cabs",
                            leftAmount: 120 - todaysCab ,
                            progress: todaysCab/120,
                            progressColor: Colors.orange.shade400,
                            width: width * 0.4,
                            height: height * 0.015,
                          ),

                          _NutritionProgress(
                            nutrition: "Fat",
                            leftAmount: 120 - todaysFat ,
                            progress: todaysFat/120,
                            progressColor: Colors.yellow,
                            width: width * 0.4,
                            height: height * 0.015,
                          ),
                        ],
                      ),


                    ],
                  ),
                ],
              ),
            ),
            ),
          ),

          //TODAY'S MEALS
          Positioned(
            height: height,
            top: height * 0.40,
            left: 0,
            right: 0,
            child: Container(
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 8,
                        left: 32,
                        right: 16,
                      ),
                      child: Text(
                        "TODAYS MEALS",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView
                        (child: Column(
                            
                            children: <Widget>[
                              if(todaysMeals != null)
                              for(int i = 0; i < todaysMeals!.length; i++)
                                MealCard2(meal: todaysMeals![i],
                              ),
                            ],
                        )
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.blueAccent,
                      ),
                    ), 
                ],
              ),
            ),
          ),
        ],
      ), 
      //ADD MEAL
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          showDialog(context: context, builder: (context){
            return AlertDialog(
              scrollable: true,
              title: Text("Add Meal"),
              content: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                     TextField(controller: mealNameEC,),
                  ],
                ),
              ),
              actions: [
              //MEAL API
                ElevatedButton(
                    onPressed: () async {
                    try {
                      final nutritionData = await fetchFoodNutrition(mealNameEC.text);
                      Meal meal = Meal.fromJson(nutritionData);
                      DateTime today = DateTime(todayDateWithHours.year,todayDateWithHours.month,todayDateWithHours.day);
                      AddToMealHistory(today, meal);
                      setState(() {
                        todaysMeals = getTodaysMeals(todaysDate);
                      });
                      print(meal);
                    } catch (e) {
                      print('Error: $e');
                    }
                  }, 
                  child: Text('Add Meal'),
                  ),
                //OWN MEAL
                ElevatedButton(
                    onPressed: (){
                      showDialog(context: context, builder: (context)
                      {
                        return AlertDialog(
                            scrollable: true,
                            title: Text("Event Name"),
                            content: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                TextField(controller: mealNameEC,),
                                TextField(controller: calsEC,keyboardType: TextInputType.number,),
                                TextField(controller: proteinEC,keyboardType: TextInputType.number,),
                                TextField(controller: cabsEC,keyboardType: TextInputType.number,),
                                TextField(controller: fatsEC,keyboardType: TextInputType.number,),
                              ],
                            ),
                            ),
                            actions: [
                              ElevatedButton(onPressed: ()
                              {
                                Meal newMeal = Meal(
                                  name: mealNameEC.text,
                                  calory:  double.parse(calsEC.text),
                                  protein: double.parse(proteinEC.text),
                                  cabs:    double.parse(cabsEC.text),
                                  fats:    double.parse(fatsEC.text)
                                );
                                AddToMealHistory(todaysDate, newMeal);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                setState(() {
                                  todaysMeals = getTodaysMeals(todaysDate);
                                });
                              },
                              child: Text("Add")),
                            ],
                        );
                      });
                    }, 
                  child: Text('Add your own'),
                  ),
              ],
            );
            });
        },
        child: Row(
          children: [
            const Icon(Icons.add),
            const Icon(Icons.dining_sharp),
          ],
        ),
        ),

    );
  }
}

double setTodaysNutritions(List<Meal>? todaysMeals,List<double>? todaysNutritions)
{
  double totalCalory = 0;
  if(todaysMeals == null) return 0;
  if(todaysNutritions == null) return 0;
  todaysNutritions[0] = 0;todaysNutritions[1] = 0;todaysNutritions[2] = 0;todaysNutritions[3] = 0;

  for(int i = 0; i < todaysMeals.length; i++)
  {
    todaysNutritions[0] += todaysMeals[i].calory;
    todaysNutritions[1] += todaysMeals[i].protein;
    todaysNutritions[2] += todaysMeals[i].cabs;
    todaysNutritions[3] += todaysMeals[i].fats;
  }
  return totalCalory;
}




class _NutritionProgress extends StatelessWidget {
  final String nutrition;
  final double leftAmount;
  final double progress,width,height;
  final Color progressColor;

  const _NutritionProgress({super.key, required this.nutrition, required this.leftAmount, required this.progress,this.width = 0,this.height = 0, required this.progressColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          nutrition.toUpperCase(),
           style:  const TextStyle(
              fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: <Widget>[
            Stack(
              children:[
                Container(
                  height: height,
                  width: width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)), color:Colors.black12,
                ),
              ),
              Container(
                  height: height,
                  width: width * min(1, progress),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)), color: progressColor,
                ),
              ),
              ],
            ),
            Text("${leftAmount}g left"),
          ],
        ),
      ],
    );
  }
}

class _RadialProgress extends StatelessWidget {

  final double height,width,progress,calLeft;
  const _RadialProgress({super.key, required this.height, required this.width, required this.progress, required this.calLeft});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      //RADIAL
      painter: _RadialPainter(progress: progress,Colors.purpleAccent),
      //KCAL LEFT TEXT
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: calLeft.toString(), style: Theme.of(context).textTheme.bodyText2),
                TextSpan(text: "\n"),
                TextSpan(text: "kcal left", style: Theme.of(context).textTheme.bodyText2)
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter
{
  final double progress;
  final Color color;

  _RadialPainter(this.color, {required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintProgress = Paint()
    ..strokeWidth = 10
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
    Paint paintBack = Paint()
    ..strokeWidth = 10
    ..color = Colors.black12
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
 
    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width /2),
      math.radians(-90),
      math.radians(-relativeProgress), 
      false,
      paintProgress);
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width/2),
      math.radians(-90),
      math.radians(360), 
      false,
      paintBack);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class _MealCard extends StatelessWidget {
  final Meal meal;
  
  const _MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20, bottom: 10,),     
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        elevation: 4,
        child: Row(
          mainAxisSize:  MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  //MEAL NAME
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(meal.name),
                  ),
                  Expanded(child: SizedBox()),
                  //GR AND NUTRITION VALUES
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(meal.calory.toString() + " GR  " + meal.calory.toString() + " Calory"),
                        Row(
                          children: [
                            Text(meal.cabs.toString() + " Cabs"),
                            Text(meal.fats.toString() + " Fats"),
                            Text(meal.protein.toString() + " Protein"),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}