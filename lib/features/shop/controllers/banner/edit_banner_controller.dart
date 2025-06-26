import 'package:e_commerce_admin/features/media/controllers/media_controller.dart';
import 'package:e_commerce_admin/features/media/models/image_model.dart';
import 'package:e_commerce_admin/utils/helpers/network_manager.dart';
import 'package:e_commerce_admin/utils/popups/full_screen_loader.dart';
import 'package:e_commerce_admin/utils/popups/loaders.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/banner/banner_repository.dart';
import '../../models/banner_model.dart';
import 'banner_controller.dart';

class EditBannerController extends GetxController {
  static EditBannerController get instance => Get.find();

  RxString imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final formKey = GlobalKey<FormState>();
  final repository = Get.put(BannerRepository());

  //Init Data
  void init(BannerModel banner) {
    imageURL.value = banner.imageUrl;
    isActive.value = banner.active;
  }

  //Update Banner
  Future<void> updateBanner(BannerModel banner) async {
    try {
      //Start Loading
      TFullScreenLoader.popUpCircular();

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

      //Is data Updated
      if (banner.imageUrl != imageURL.value ||
          banner.active != isActive.value) {
        //Map Data
        banner.imageUrl = imageURL.value;
        banner.active = isActive.value;

        await repository.updateBanner(banner);
      }

      //Update All Data List
      BannerController.instance.updateItemFromLists(banner);

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Success Message
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your Banner has been Updated.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //Image Picker thumbnail
  void pickImage() async {
    final controller = Get.put(MediaController());

    List<ImageModel>? selectedImages =
        await controller.selectedImagesFromMedia();

    if (selectedImages!.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;

      imageURL.value = selectedImage.url;
    }
  }
}
