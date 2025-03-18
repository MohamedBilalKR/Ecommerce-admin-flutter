import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/features/shop/models/banner_model.dart';
import 'package:e_commerce_admin/utils/exceptions/firebase_exceptions.dart';
import 'package:e_commerce_admin/utils/exceptions/format_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/exceptions/platform_exceptions.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  //Firebase Firestore Instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Get All caBanners
  Future<List<BannerModel>> getAllBanners() async {
    try {
      final snapshot = await _db.collection('Banners').get();
      final result = snapshot.docs.map((doc) => BannerModel.fromSnapshot(doc)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  //Add New Banners
  Future<String> createBanner(BannerModel banner) async {
    try {
      final data = await _db.collection('Banners').add(banner.toJson());
      return data.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  //Update Banners
  Future<void> updateBanner(BannerModel banner) async {
    try {
      await _db.collection('Banners').doc(banner.id).update(banner.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  //Delete Banners
  Future<void> deleteBanner(String bannerId) async {
    try {
      await _db.collection('Banners').doc(bannerId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try Again';
    }
  }
}
