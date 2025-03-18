import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/personalization/models/settings_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class SettingsRepository extends GetxController {
  static SettingsRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Save Setting Data
  Future<void> registerSettings(SettingsModel setting) async {
    try {
      await _db.collection('Settings').doc('GLOBAL_SETTINGS').set(setting.toJson());
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

  //Fetch Settings Details
  Future<SettingsModel> getSettings() async {
    try {
      final querySnapshot = await _db.collection('Settings').doc('GLOBAL_SETTINGS').get();
      return SettingsModel.fromSnapshot(querySnapshot);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Somenting Went Wrong: $e');
      throw 'Something went wrong: $e';
    }
  }

  //Update Settings
  Future<void> updateSettingDetails(SettingsModel updateSetting) async {
    try {
      await _db.collection('Settings').doc('GLOBAL_SETTINGS').update(updateSetting.toJson());
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

  //Update Single Field
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection('Settings').doc('GLOBAL_SETTINGS').update(json);
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
