import 'package:e_commerce_admin/features/media/controllers/media_controller.dart';
import 'package:e_commerce_admin/features/media/models/image_model.dart';
import 'package:e_commerce_admin/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../models/user_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    fetchUserDetails();
    super.onInit();
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      loading.value = true;
      final user = await userRepository.fetchAdminDetails();
      this.user.value = user;
      loading.value = false;

      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      phoneController.text = user.phoneNumber;

      return user;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Somethinh went wrong', message: e.toString());
      return UserModel.empty();
    }
  }

  //Pick Thumbnail from medi
  void updateAppLogo() async {
    try {
      loading.value = true;
      final controller = Get.put(MediaController());
      List<ImageModel>? selectedImages = await controller.selectedImagesFromMedia();

      if (selectedImages != null && selectedImages.isNotEmpty) {
        ImageModel selectedImage = selectedImages.first;

        await userRepository.updateSingleField({'ProfilePicture': selectedImage.url});

        user.value.profilePicture = selectedImage.url;
        user.refresh();

        TLoaders.successSnackBar(
            title: 'Congratualtions', message: 'Your Profile Picture has been updated.');
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void updateUserInformation() async {
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

    user.value.firstName = firstNameController.text.trim();
    user.value.lastName = lastNameController.text.trim();
    user.value.phoneNumber = phoneController.text.trim();
      

      await userRepository.updateUserDetails(user.value);
      user.refresh();

      loading.value = false;
      TLoaders.successSnackBar(
          title: 'Congratualtions', message: 'App Settings has been updated.');
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
