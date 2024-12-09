import 'package:dart_fusion/dart_fusion.dart';

enum HomePricingType { month, year, forever }

@model
class HomePricingModel extends DModel {
  const HomePricingModel({
    required this.title,
    required this.price,
    required this.benefits,
    required this.type,
  });

  @variable
  final String title;

  @variable
  final int price;

  @variable
  final String benefits;

  @Variable(defaultsTo: HomePricingType.month)
  final HomePricingType type;
}
