import 'package:e_commerce_admin/data/repositories/category/category_repository.dart';
import 'package:e_commerce_admin/features/shop/controllers/category/category_controller.dart';
import 'package:e_commerce_admin/features/shop/models/category_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';

class EditCategoryController extends GetxController {
  static EditCategoryController get instance => Get.find();

  final selectedParent = CategoryModel.empty().obs;
  final loading = false.obs;
  RxString imageURL = ''.obs;
  RxString banner = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();

  //Init Data
  void init(CategoryModel category) {
    name.text = category.name;
    isFeatured.value = category.isFeatured;
    imageURL.value = category.image;
    banner.value = category.banner!;
    if (category.parentId.isNotEmpty) {
      selectedParent.value = CategoryController.instance.allItems
          .where((c) => c.id == category.parentId)
          .single;
    }
  }

  //Update Category
  Future<void> updateCategory(CategoryModel category) async {
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
      category.image = imageURL.value;
      category.banner = banner.value;
      category.name = name.text.trim();
      category.parentId = selectedParent.value.id;
      category.isFeatured = isFeatured.value;
      category.updatedAt = DateTime.now();

      //Call Repository to Update Category
      await CategoryRepository.instance.updateCategory(category);

      //Update all Data List
      CategoryController.instance.updateItemFromLists(category);

      //Reset Form
      // resetFields();

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Success Message
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'New Category has been added.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //Image Picker thumbnail
  void pickImageThumbnail() async {
    final controller = Get.put(MediaController());

    List<ImageModel>? selectedImages =
        await controller.selectedImagesFromMedia();

    if (selectedImages!.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;

      imageURL.value = selectedImage.url;
    }
  }

  //Image Picker thumbnail
  void pickImageBanner() async {
    final controller = Get.put(MediaController());

    List<ImageModel>? selectedImages =
        await controller.selectedImagesFromMedia();

    if (selectedImages!.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;

      banner.value = selectedImage.url;
    }
  }

  //Reset Fields
  // void resetFields() {
  //   selectedParent(CategoryModel.empty());
  //   loading(false);
  //   isFeatured(false);
  //   name.clear();
  //   imageURL.value = '';
  //   banner.value = '';
  // }
}
