import 'package:flutter/material.dart';
import 'package:nutrition_app/model/meal.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final today = DateTime.now();

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
                      "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}",
                      ),
                    subtitle: Text("Hello, Ikbal"),
                    //trailing: , Profile Picture
                  ),
                  //PRROGRESSES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                       // RADIAL PROGRESS

                       
                      _RadialProgress(
                        width: width * 0.25,
                        height: height * 0.25,
                        progress:  getTotalCalory() / 2500,
                      ),
                      //NUTRITION PROGRESS
                      Column(
                        children: <Widget>[

                          _NutritionProgress(
                            nutrition: "Protein",
                            leftAmount: 72 ,
                            progress: 0.5,
                            progressColor: Colors.green.shade400,
                            width: width * 0.4,
                            height: height * 0.015,
                          ),

                          _NutritionProgress(
                            nutrition: "Cabs",
                            leftAmount: 72 ,
                            progress: 0.5,
                            progressColor: Colors.orange.shade400,
                            width: width * 0.4,
                            height: height * 0.015,
                          ),

                          _NutritionProgress(
                            nutrition: "Fat",
                            leftAmount: 72 ,
                            progress: 0.5,
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
                        "TODAY'S MEALS",
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
                              for(int i = 0; i < meals.length; i++)
                                _MealCard(meal: meals[i],
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

      //BOTTOM NAVIGATION BAR
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        child: BottomNavigationBar(

          iconSize: 40,
          selectedIconTheme: const IconThemeData(
            color: Color(0xFF200087),
          ),
          unselectedIconTheme: const IconThemeData(
            color: Colors.black,
          ),
          showSelectedLabels: true,
          showUnselectedLabels: false,
      
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.home
                ),
              ),
            ),
      
            BottomNavigationBarItem(
              label: "Search",
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.search
                ),
              ),
            ),
      
            BottomNavigationBarItem(
              label: "Profile",
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.person
                ),
              ),
            ),
            
          ],
      
        //Add a label style here TOO ADD! 
        ),
      ),
    );
  }
}

int getTotalCalory()
{
  int totalCalory = 0;
  for(int i = 0; i < meals.length; i++)
  {
    totalCalory += meals[i].calory;
  }
  return totalCalory;
}

class _NutritionProgress extends StatelessWidget {
  final String nutrition;
  final int leftAmount;
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
                  width: width * progress,
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

  final double height,width,progress;
  const _RadialProgress({super.key, required this.height, required this.width, required this.progress});

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
                TextSpan(text: "1731", style: Theme.of(context).textTheme.bodyText2),
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