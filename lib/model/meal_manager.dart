import 'package:flutter/material.dart';
import 'package:nutrition_app/model/meal.dart';

Map<DateTime,List<Meal>> mealHistory = {};

void AddToMealHistory(DateTime day,Meal meal)
{
  if(!mealHistory.containsKey(day))
  {
    mealHistory.addAll({day: [meal]});
  }
  else
  {
    mealHistory[day]?.add(meal);
  }

}

List<Meal>? getTodaysMeals(DateTime todaysDate)
{
  List<Meal>? todaysMeals = mealHistory[todaysDate];
  return todaysMeals;
}