import 'package:e_commerce_admin/features/media/controllers/media_controller.dart';
import 'package:e_commerce_admin/features/media/models/image_model.dart';
import 'package:e_commerce_admin/features/personalization/models/settings_model.dart';
import 'package:e_commerce_admin/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/setting/settings_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  RxBool loading = false.obs;
  Rx<SettingsModel> settings = SettingsModel().obs;

  final formKey = GlobalKey<FormState>();
  final appNameController = TextEditingController();
  final taxController = TextEditingController();
  final shippingController = TextEditingController();
  final freeShippingController = TextEditingController();

  final settingsRepository = Get.put(SettingsRepository());

  @override
  void onInit() {
    fetchSettingDetails();
    super.onInit();
  }

  Future<SettingsModel> fetchSettingDetails() async {
    try {
      loading.value = true;
      final settings = await settingsRepository.getSettings();
      this.settings.value = settings;

      appNameController.text = settings.appName;
      taxController.text = settings.taxRate.toString();
      shippingController.text = settings.shippingCost.toString();
      freeShippingController.text = settings.freeShippingThreshold == null
          ? ''
          : settings.freeShippingThreshold.toString();

      loading.value = false;

      return settings;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Somethinh went wrong', message: e.toString());
      return SettingsModel();
    }
  }

  //Pick Thumbnail from medi
  void updateAppLogo() async {
    try {
      loading.value = true;
      final controller = Get.put(MediaController());
      List<ImageModel>? selectedImages =
          await controller.selectedImagesFromMedia();

      if (selectedImages!.isNotEmpty) {
        ImageModel selectedImage = selectedImages.first;

        await settingsRepository
            .updateSingleField({'AppLogo': selectedImage.url});

        settings.value.appLogo = selectedImage.url;
        settings.refresh();

        TLoaders.successSnackBar(
            title: 'Congratualtions', message: 'App Logo has been updated.');
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void updateSettingInformation() async {
    try {
      loading.value = true;

      //Check internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Form Validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      settings.value.appName = appNameController.text.trim();
      settings.value.taxRate =
          double.tryParse(taxController.text.trim()) ?? 0.0;
      settings.value.shippingCost =
          double.tryParse(shippingController.text.trim()) ?? 0.0;
      settings.value.freeShippingThreshold =
          double.tryParse(freeShippingController.text.trim()) ?? 0.0;

      await settingsRepository.updateSettingDetails(settings.value);
      settings.refresh();

      loading.value = false;
      TLoaders.successSnackBar(
          title: 'Congratualtions', message: 'App Settings has been updated.');
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
