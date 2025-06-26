import 'package:e_commerce_admin/features/media/controllers/media_controller.dart';
import 'package:e_commerce_admin/features/media/models/image_model.dart';
import 'package:e_commerce_admin/features/shop/models/product_variation_model.dart';
import 'package:get/get.dart';

class ProductImagesController extends GetxController {
  static ProductImagesController get instance => Get.find();

  Rx<String?> selectedThumbnailImageUrl = Rx<String?>(null);

  final RxList<String> additionalProductImagesUrls = <String>[].obs;

  //Pick Thumbnail Images
  void selectThumbnailImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages =
        await controller.selectedImagesFromMedia();

    if (selectedImages!.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;

      selectedThumbnailImageUrl.value = selectedImage.url;
    }
  }

  //Pick Multiple Image
  void selectMultipleProductImage() async {
    final controller = Get.put(MediaController());
    final selectedImages = await controller.selectedImagesFromMedia(
        multipleSelection: true, selectedUrls: additionalProductImagesUrls);

    if (selectedImages != null && selectedImages.isNotEmpty) {
      additionalProductImagesUrls.assignAll(selectedImages.map((e) => e.url));
    }
  }

  //Select variation Images
  void selectVariationImage(ProductVariationModel variation) async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages =
        await controller.selectedImagesFromMedia();

    if (selectedImages!.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      variation.image.value = selectedImage.url;
    }
  }

  //Function to remove product
  Future<void> removeImage(int index) async {
    additionalProductImagesUrls.removeAt(index);
  }
}
