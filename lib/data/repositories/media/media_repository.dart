import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:e_commerce_admin/features/media/models/image_model.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../data.dart';

class MediaRepository extends GetxController {
  static MediaRepository get instance => Get.find();

  //Cloudinary Image Upload
  Future<ImageModel?> uploadImageToCloudinary({
    required Uint8List fileData,
    required String mimeType,
    required String path,
    required String imageName,
  }) async {
    try {
      const String apiUrl =
          'https://api.cloudinary.com/v1_1/dxaigliku/image/upload';

      //Sanitize folder & filename (No Slashes, Special Chars)
      String sanitizedFilename =
          imageName.trim().replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '');

      //Convert image to Multipart File
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['upload_preset'] = 'ecommerceadmin'
        ..fields['public_id'] = sanitizedFilename
        ..files.add(http.MultipartFile.fromBytes('file', fileData,
            filename: sanitizedFilename,
            contentType: MediaType.parse(mimeType)));

      //Send POST request to Cloudinary
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final folder = path;
      final fullPath = '$path/$sanitizedFilename';

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);
        return ImageModel.fromCloudinaryResponse(
            jsonResponse, folder, fullPath);
      } else {
        throw 'Upload failed: $responseBody';
      }
    } catch (e) {
      throw 'Error uploading to Cloudinary: $e';
    }
  }

  //Upload Image data in Firestore
  Future<String> uploadImageFileInDatabase(ImageModel image) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('Images')
          .add(image.toJson());
      return data.id;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  //Fetch Images From Database
  Future<List<ImageModel>> fetchImagesFromDatabase(
      MediaCategory mediaCategory, int loadCount) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Images')
          .where('MediaCategory', isEqualTo: mediaCategory.name.toString())
          .orderBy('CreatedAt', descending: true)
          .limit(loadCount)
          .get();

      return querySnapshot.docs.map((e) => ImageModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  //Load more Images
  Future<List<ImageModel>> loadMoreImagesFromDatabase(
      MediaCategory mediaCategory,
      int loadCount,
      DateTime lastFetchedDate) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Images')
          .where('MediaCategory', isEqualTo: mediaCategory.name.toString())
          .orderBy('CreatedAt', descending: true)
          .startAfter([lastFetchedDate])
          .limit(loadCount)
          .get();

      return querySnapshot.docs.map((e) => ImageModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  //Delete Image from Cloudinary
  Future<void> deleteImageFromCloudinary(ImageModel image) async {
    try {
      if (image.filename.isEmpty) {
        throw 'Invalid image public ID';
      }

      // Generate a secure signature
      final int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final String signatureRaw =
          'public_id=${image.filename}&timestamp=$timestamp$apiSecret';
      final String signature =
          sha1.convert(utf8.encode(signatureRaw)).toString();

      // Cloudinary API URL
      final String apiUrl =
          'https://api.cloudinary.com/v1_1/$cloudName/image/destroy';

      // Make DELETE request to Cloudinary
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'public_id': image.filename,
          'api_key': apiKey,
          'timestamp': timestamp.toString(),
          'signature': signature,
        },
      );

      if (response.statusCode != 200) {
        throw 'Failed to delete image from Cloudinary: ${response.body}';
      }

      // Delete from Firestore after Cloudinary deletion
      await FirebaseFirestore.instance
          .collection('Images')
          .doc(image.id)
          .delete();
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } on SocketException {
      throw 'No internet connection';
    } catch (e) {
      throw 'Error deleting file: $e';
    }
  }
}
