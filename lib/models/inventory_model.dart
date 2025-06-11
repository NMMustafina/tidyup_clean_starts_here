import 'package:hive/hive.dart';

part 'inventory_model.g.dart';

@HiveType(typeId: 1)
class InventoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String location;

  @HiveField(4)
  final DateTime? purchaseDate;

  @HiveField(5)
  final int? retentionPeriod;

  @HiveField(6)
  final String? photoPath;

  InventoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.purchaseDate,
     this.retentionPeriod,
    this.photoPath,
  });
}
