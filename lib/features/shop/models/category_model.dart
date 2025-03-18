import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/utils/formatters/formatter.dart';

class CategoryModel {
  String id;
  String name;
  String image;
  String? banner;
  String parentId;
  bool isFeatured;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured = false,
    this.parentId = '',
    this.banner,
    this.createdAt,
    this.updatedAt,
  });

  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedDate => TFormatter.formatDate(updatedAt);

  //Empty Helper Function
  static CategoryModel empty() => CategoryModel(id: '', name: '', image: '');

  //Convert model to json structure to store data in firebase
  toJson() {
    return {
      'Name': name,
      'Image': image,
      'Banner': banner,
      'ParentId': parentId,
      'IsFeatured': isFeatured,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  //Map Json oriented document snapshot
  factory CategoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data();

      //Map Json Record to model
      return CategoryModel(
        id: document.id,
        name: data?['Name'] ?? '',
        image: data?['Image'] ?? '',
        banner: data?['Banner'] ?? '',
        parentId: data?['ParentId'] ?? '',
        isFeatured: data?['IsFeatured'] ?? false,
        createdAt: data!.containsKey('CreatedAt') ? data['CreatedAt']?.toDate() : null,
        updatedAt: data.containsKey('UpdatedAt') ? data['UpdatedAt']?.toDate() : null,
      );
    } else {
      return CategoryModel.empty();
    }
  }
}
