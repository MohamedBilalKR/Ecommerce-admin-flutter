import 'package:e_commerce_admin/data/repositories/brand/brand_repository.dart';
import 'package:e_commerce_admin/features/media/controllers/media_controller.dart';
import 'package:e_commerce_admin/features/media/models/image_model.dart';
import 'package:e_commerce_admin/features/shop/controllers/brand/brand_controller.dart';
import 'package:e_commerce_admin/features/shop/models/brand_category_model.dart';
import 'package:e_commerce_admin/features/shop/models/brand_model.dart';
import 'package:e_commerce_admin/features/shop/models/category_model.dart';
import 'package:e_commerce_admin/utils/helpers/network_manager.dart';
import 'package:e_commerce_admin/utils/popups/full_screen_loader.dart';
import 'package:e_commerce_admin/utils/popups/loaders.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EditBrandController extends GetxController {
  static EditBrandController get instance => Get.find();

  final loading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final repository = Get.put(BrandRepository());
  final List<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  //Init Data
  void init(BrandModel brand) {
    name.text = brand.name;
    imageURL.value = brand.image;
    isFeatured.value = brand.isFeatured;
    if (brand.brandCategories != null) {
      selectedCategories.addAll(brand.brandCategories ?? []);
      ;
    }
  }

  //Toggle Category Selection
  void toggleSelection(CategoryModel category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  //Image Picker
  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages =
        await controller.selectedImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;

      imageURL.value = selectedImage.url;
    }
  }

  //Update Brand
  Future<void> updateBrand(BrandModel brand) async {
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

      //Is Data Updated
      bool isBrandUpdated = false;
      if (brand.image != imageURL.value ||
          brand.name != name.text.trim() ||
          brand.isFeatured != isFeatured.value) {
        isBrandUpdated = true;

        //Map Data
        brand.image = imageURL.value;
        brand.name = name.text.trim();
        brand.isFeatured = isFeatured.value;
        brand.updatedAt = DateTime.now();

        //Call Repository to Update
        await repository.updateBrand(brand);
      }

      //Update BrandCategory
      if (selectedCategories.isNotEmpty) await updateBrandCategories(brand);

      //Update Brand data in Product
      if (isBrandUpdated) await updateBrandInProduct(brand);

      //Update All Data List
      BrandController.instance.updateItemFromLists(brand);

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Success Message
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your Brand has been updated.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //Update Categories of this Brand
  updateBrandCategories(BrandModel brand) async {
    //Fetch All BrandCategories
    final brandCategories =
        await repository.getCategoriesOfSpecificBrand(brand.id);

    //SelectCategoriesId
    final selectedCategoryIds = selectedCategories.map((e) => e.id);

    //Identify Categories to Remove
    final categoriesToRemove = brandCategories
        .where((existingCategory) =>
            !selectedCategoryIds.contains(existingCategory.categoryId))
        .toList();

    //Remove Unselected categories
    for (var categoryToRemove in categoriesToRemove) {
      await BrandRepository.instance
          .deleteBrandCategory(categoryToRemove.id ?? '');
    }

    //Identify New Categories to add
    final newCategoriesToAdd = selectedCategories
        .where((newCategory) => !brandCategories.any((existingCategory) =>
            existingCategory.categoryId == newCategory.id))
        .toList();

    //Add New Categories
    for (var newCategory in newCategoriesToAdd) {
      var brandCategory =
          BrandCategoryModel(brandId: brand.id, categoryId: newCategory.id);
      brandCategory.id =
          await BrandRepository.instance.createBrandCategory(brandCategory);
    }

    brand.brandCategories!.assignAll(selectedCategories);
    BrandController.instance.updateItemFromLists(brand);
  }

  updateBrandInProduct(BrandModel brand) {}

  //Reset Fields
  // void resetFields() {
  //   name.clear();
  //   loading(false);
  //   isFeatured(false);
  //   imageURL.value = '';
  //   selectedCategories.clear();
  // }
}
