import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/utils/formatters/formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ImageModel {
  String id;
  final String url;
  final String folder;
  final int? sizeBytes;
  String mediaCategory;
  final String filename;
  final String? fullPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contentType;

  //Not Mapped
  final File? file;
  RxBool isSelected = false.obs;
  final Uint8List? localImageToDisplay;

  //Constructor
  ImageModel({
    this.id = '',
    required this.url,
    required this.folder,
    required this.filename,
    this.sizeBytes,
    this.fullPath,
    this.createdAt,
    this.updatedAt,
    this.contentType,
    this.file,
    this.localImageToDisplay,
    this.mediaCategory = '',
  });

  //Static function to create an empty model
  static ImageModel empty() => ImageModel(url: '', folder: '', filename: '');

  String get createdAtFormatted => TFormatter.formatDate(createdAt);

  String get updatedAtFormatted => TFormatter.formatDate(updatedAt);

  //Convert to Json to Store in DB
  Map<String, dynamic> toJson() {
    return {
      'Url': url,
      'Folder': folder,
      'SizeBytes': sizeBytes,
      'Filename': filename,
      'FullPath': fullPath,
      'CreatedAt': createdAt?.toUtc(),
      'ContentType': contentType,
      'MediaCategory': mediaCategory
    };
  }

  //Convert Firestore Json and Map on Model
  factory ImageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      //Map JSON Record to the Model
      return ImageModel(
        id: document.id,
        url: data['Url'] ?? '',
        folder: data['Folder'] ?? '',
        sizeBytes: data['SizeBytes'] ?? 0,
        filename: data['Filename'] ?? '',
        fullPath: data['FullPath'] ?? '',
        createdAt:
            data.containsKey('CreatedAt') ? data['CreatedAt']?.toDate() : null,
        updatedAt:
            data.containsKey('UpdatedAt') ? data['UpdatedAt']?.toDate() : null,
        contentType: data['ContentType'] ?? '',
        mediaCategory: data['MediaCategory'],
      );
    } else {
      return ImageModel.empty();
    }
  }

  //Map Firebase Storage Data
  factory ImageModel.fromFirebaseMetadata(FullMetadata metadata, String folder,
      String filename, String downloadUrl) {
    return ImageModel(
      url: downloadUrl,
      folder: folder,
      filename: filename,
      sizeBytes: metadata.size,
      updatedAt: metadata.updated,
      fullPath: metadata.fullPath,
      createdAt: metadata.timeCreated,
    );
  }

  // Map Cloudinary Response Data
  factory ImageModel.fromCloudinaryResponse(
      Map<String, dynamic> json, String folder, String fullPath) {
    return ImageModel(
      url: json['secure_url'], // Cloudinary secure URL
      folder: folder, // Cloudinary folder
      filename:
          json['public_id'] ?? '', // Public ID instead of original filename
      sizeBytes: json['bytes'], // Image size in bytes
      contentType: json['format'], // File format (e.g., jpg, png)
      fullPath: fullPath, // Full path in Cloudinary
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.now(), // Upload timestamp
    );
  }
}
