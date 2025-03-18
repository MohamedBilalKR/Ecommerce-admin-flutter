import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/features/shop/models/brand_model.dart';

import '../../../utils/formatters/formatter.dart';
import 'product_attribute_model.dart';
import 'product_variation_model.dart';

class ProductModel {
  String id;
  int stock;
  String? sku;
  double price;
  String title;
  DateTime? date;
  double salePrice;
  String thumbnail;
  bool? isFeatured;
  BrandModel? brand;
  String? categoryId;
  String productType;
  String? description;
  List<String>? images;
  int soldQuantity;
  List<ProductAttributeModel>? productAttributes;
  List<ProductVariationModel>? productVariations;

  ProductModel({
    required this.id,
    required this.stock,
    required this.price,
    required this.title,
    required this.thumbnail,
    required this.productType,
    this.soldQuantity = 0,
    this.sku,
    this.date,
    this.images,
    this.isFeatured,
    this.brand,
    this.description,
    this.categoryId,
    this.productAttributes,
    this.productVariations,
    this.salePrice = 0.0,
  });

  // Empty Helper Function
  static ProductModel empty() => ProductModel(
        id: '',
        stock: 0,
        price: 0,
        title: '',
        thumbnail: '',
        productType: '',
      );

  String get formattedDate => TFormatter.formatDate(date);

  // Convert to JSON
  toJson() {
    return {
      'SKU': sku,
      'Stock': stock,
      'Price': price,
      'Date': date,
      'Title': title,
      'Thumbnail': thumbnail,
      'ProductType': productType,
      'SalePrice': salePrice,
      'Images': images ?? [],
      'IsFeatured': isFeatured,
      'Brand': brand!.toJson(),
      'Description': description,
      'SoldQuantity': soldQuantity,
      'CategoryId': categoryId,
      'ProductAttributes': productAttributes != null
          ? productAttributes!.map((e) => e.toJson()).toList()
          : [],
      'ProductVariations': productVariations != null
          ? productVariations!.map((e) => e.toJson()).toList()
          : [],
    };
  }

  // Map JSON document snapshot from Firebase to model
  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return ProductModel.empty();
    final data = document.data()!;
    return ProductModel(
      id: document.id,
      sku: data['SKU'] ?? '',
      title: data['Title'] ?? '',
      stock: data['Stock'] ?? 0,
      soldQuantity: data.containsKey('SoldQuantity') ? data['SoldQuantity'] ?? 0 : 0,
      price: double.tryParse(data['Price']?.toString() ?? '0.0') ?? 0.0,
      salePrice: double.tryParse(data['SalePrice']?.toString() ?? '0.0') ?? 0.0,
      thumbnail: data['Thumbnail'] ?? '',
      productType: data['ProductType'] ?? '',
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      isFeatured: data['IsFeatured'] ?? false,
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      date: data.containsKey('Date') ? data['Date']?.toDate() : null,
      description: data['Description'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      productAttributes: data['ProductAttributes'] != null
          ? (data['ProductAttributes'] as List<dynamic>)
              .map((e) => ProductAttributeModel.fromJson(e))
              .toList()
          : [],
      productVariations: data['ProductVariations'] != null
          ? (data['ProductVariations'] as List<dynamic>)
              .map((e) => ProductVariationModel.fromJson(e))
              .toList()
          : [],
    );
  }

  // Map JSON query document snapshot from Firebase to model
  factory ProductModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return ProductModel(
      id: document.id,
      sku: data['SKU'] ?? '',
      title: data['Title'] ?? '',
      stock: data['Stock'] ?? 0,
      soldQuantity: data.containsKey('SoldQuantity') ? data['SoldQuantity'] ?? 0 : 0,
      price: double.tryParse(data['Price']?.toString() ?? '0.0') ?? 0.0,
      salePrice: double.tryParse(data['SalePrice']?.toString() ?? '0.0') ?? 0.0,
      thumbnail: data['Thumbnail'] ?? '',
      productType: data['ProductType'] ?? '',
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      isFeatured: data['IsFeatured'] ?? false,
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      date: data.containsKey('Date') ? data['Date']?.toDate() : null,
      description: data['Description'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      productAttributes: data['ProductAttributes'] != null
          ? (data['ProductAttributes'] as List<dynamic>)
              .map((e) => ProductAttributeModel.fromJson(e))
              .toList()
          : [],
      productVariations: data['ProductVariations'] != null
          ? (data['ProductVariations'] as List<dynamic>)
              .map((e) => ProductVariationModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
