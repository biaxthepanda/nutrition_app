import 'dart:ffi';

import 'package:flutter/material.dart';


class Meal{
    final String name;
    final double protein,cabs,fats,calory;

    Meal({
      required this.name,
      required this.protein,
      required this.cabs,
      required this.fats,
      required this.calory,
    });

    factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['name'],
      protein: double.parse(json['protein_g']) ,
      cabs: double.parse(json['carbohydrates_total_g']),
      fats: double.parse(json['fat_total_g']),
      calory: double.parse(json['calories']),
    );
  }
  }

class MealCard2 extends StatelessWidget {
  final Meal meal;
  const MealCard2({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20, bottom: 10,left: 20),     
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


  

  final meals = [

    Meal(
      name: "asdsa",
      protein: 10,
      cabs: 10,
      fats: 10,
      calory: 10,
    ),
    Meal(
      name: "fdsfas",
      protein: 10,
      cabs: 10,
      fats: 10,
      calory: 10,
    ),
    Meal(
      name: "wqewq",
      protein: 10,
      cabs: 10,
      fats: 10,
      calory: 10,
    ),
    Meal(
      name: "fgnhgfn",
      protein: 10,
      cabs: 10,
      fats: 10,
      calory: 10,
    ),
  ];