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

class CreateBannerController extends GetxController {
  static CreateBannerController get instance => Get.find();

  RxString imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final formKey = GlobalKey<FormState>();

  //Register new Category
  Future<void> createBanner() async {
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

      //Map Data
      final newRecord = BannerModel(
        id: '',
        active: isActive.value,
        imageUrl: imageURL.value,
      ); 

      newRecord.id = await BannerRepository.instance.createBanner(newRecord);

      //Update All Data List
      BannerController.instance.addItemToLists(newRecord);

      //Reset Form
      resetFields();

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Success Message
      TLoaders.successSnackBar(title: 'Congratulations', message: 'New Banner has been added.');

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

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;

      imageURL.value = selectedImage.url;
    }
  }
  
  //Reset Fields
  void resetFields() {
    loading(false);
    isActive(false);
    imageURL.value = '';
  }
}
