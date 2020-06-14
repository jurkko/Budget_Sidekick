import 'package:budget_sidekick/Models/category.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';



 
  drawChart(graphData){
        return [
      new charts.Series<Category, int>(
        id: 'category',
        domainFn: (Category category, _) => category.iconCode,
        measureFn: (Category category, _) => category.iconCode,
        data: graphData,
      )
    ];
  }