import 'package:e_commerce_admin/data/repositories/product/product_repository.dart';
import 'package:e_commerce_admin/features/shop/controllers/product/product_attributes_controller.dart';
import 'package:e_commerce_admin/features/shop/controllers/product/product_controller.dart';
import 'package:e_commerce_admin/features/shop/controllers/product/product_images_controller.dart';
import 'package:e_commerce_admin/features/shop/controllers/product/product_variations_controller.dart';
import 'package:e_commerce_admin/features/shop/models/brand_model.dart';
import 'package:e_commerce_admin/features/shop/models/category_model.dart';
import 'package:e_commerce_admin/features/shop/models/product_category_model.dart';
import 'package:e_commerce_admin/features/shop/models/product_model.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:e_commerce_admin/utils/constants/image_strings.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:e_commerce_admin/utils/helpers/network_manager.dart';
import 'package:e_commerce_admin/utils/popups/full_screen_loader.dart';
import 'package:e_commerce_admin/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateProductController extends GetxController {
  static CreateProductController get instance => Get.find();

  //Observable for loading
  final isLoading = false.obs;
  final productType = ProductType.single.obs;
  final productVisibility = ProductVisibility.hidden.obs;

  //Controllers and Keys
  final stockPriceFormKey = GlobalKey<FormState>();
  final productRepository = Get.put(ProductRepository());
  final titleDescriptionFormKey = GlobalKey<FormState>();

  //Text Editing Controllers
  TextEditingController title = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController brandTextField = TextEditingController();

  //Rx Observable
  final Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);
  final RxList<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  //Flags for tracking different tasks
  RxBool thumbnailUploader = false.obs;
  RxBool additionalImagesUploader = false.obs;
  RxBool productDataUploader = false.obs;
  RxBool categoriesRelationshipUploader = false.obs;

  //Function to create Product
  Future<void> createProduct() async {
    try {
      //Show Loader
      showProgressDialog();

      //Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Validate Title and Description Form
      if (!titleDescriptionFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Validate Stock and Pricing Form
      if (productType.value == ProductType.single &&
          !stockPriceFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Ensure Brand is Selected
      if (selectedBrand.value == null) throw 'Select Brand for this Product';

      //Check variation Data
      if (productType.value == ProductType.variable &&
          ProductVariationsController.instance.productVariations.isEmpty) {
        throw 'There are no variations for the Product Type Variable. Create some variations or change Product Type';
      }

      if (productType.value == ProductType.variable) {
        final variationCheckFailed = ProductVariationsController
            .instance.productVariations
            .any((element) =>
                element.price.isNaN ||
                element.price < 0 ||
                element.salePrice.isNaN ||
                element.salePrice < 0 ||
                element.stock.isNaN ||
                element.stock < 0 ||
                element.image.value.isEmpty);

        if (variationCheckFailed) {
          throw 'Variation data is not accurate. Please recheck variations';
        }
      }

      //Upload Product Thumbnail Image
      thumbnailUploader.value = true;
      final imagesController = ProductImagesController.instance;
      if (imagesController.selectedThumbnailImageUrl.value == null) {
        throw 'Select Product Thumbnail Image';
      }

      //Additional Product Images
      additionalImagesUploader.value = true;

      //Product Variation Images
      final variations = ProductVariationsController.instance.productVariations;
      if (productType.value == ProductType.single && variations.isNotEmpty) {
        ProductVariationsController.instance.resetAllValues();
        variations.value = [];
      }

      //map Product Data
      final newRecord = ProductModel(
        id: '',
        isFeatured: true,
        title: title.text.trim(),
        brand: selectedBrand.value,
        productVariations: variations,
        description: description.text.trim(),
        productType: productType.value.toString(),
        stock: int.tryParse(stock.text.trim()) ?? 0,
        price: double.tryParse(price.text.trim()) ?? 0,
        images: imagesController.additionalProductImagesUrls,
        salePrice: double.tryParse(salePrice.text.trim()) ?? 0,
        thumbnail: imagesController.selectedThumbnailImageUrl.value ?? '',
        productAttributes: ProductAttributesController.instance.productAttributes,
        date: DateTime.now(),
      );

      //Call Repository
      productDataUploader.value = true;
      newRecord.id = await ProductRepository.instance.createProduct(newRecord);

      //Register Product Category
      if (selectedCategories.isNotEmpty) {
        if (newRecord.id.isEmpty) throw 'Error Storing Data. Try Again';

        categoriesRelationshipUploader.value = true;
        for (var category in selectedCategories) {
          final productCategory = ProductCategoryModel(
              productId: newRecord.id, categoryId: category.id);
          await ProductRepository.instance
              .createProductCategory(productCategory);
        }
      }

      //Update Product List
      ProductController.instance.addItemToLists(newRecord);

      //Reset Fields
      resetValues();

      //Stop Loader
      TFullScreenLoader.stopLoading();

      //Success Message
      shoeCompleteDialog();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snappp', message: e.toString());
    }
  }

  //Reset Form
  void resetValues() {
    isLoading.value = false;
    productType.value = ProductType.single;
    productVisibility.value = ProductVisibility.hidden;
    stockPriceFormKey.currentState?.reset();
    titleDescriptionFormKey.currentState?.reset();
    title.clear();
    description.clear();
    stock.clear();
    price.clear();
    salePrice.clear();
    brandTextField.clear();
    selectedBrand.value = null;
    selectedCategories.clear();
    ProductImagesController.instance.additionalProductImagesUrls.clear();
    ProductImagesController.instance.selectedThumbnailImageUrl.value = '';
    ProductVariationsController.instance.resetAllValues();
    ProductAttributesController.instance.resetProductAttributes();
    

    //reset upload flags
    thumbnailUploader.value = false;
    additionalImagesUploader.value = false;
    productDataUploader.value = false;
    categoriesRelationshipUploader.value = false;
  }

  void shoeCompleteDialog() {
    Get.dialog(AlertDialog(
      title: const Text('Congratulations'),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('Go to Products'))
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(TImages.productsIllustration, height: 200, width: 200),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text('Congratulations',
              style: Theme.of(Get.context!).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),
          const Text('Your Product has been Created')
        ],
      ),
    ));
  }

  void showProgressDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
        child: AlertDialog(
          title: const Text('Creating Product'),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(TImages.creatingProductIllustration,
                    height: 200, width: 200),
                const SizedBox(height: TSizes.spaceBtwItems),
                buildCheckBox('Thumbnail Image', thumbnailUploader),
                buildCheckBox('Additional Image', additionalImagesUploader),
                buildCheckBox('Product Data. Attributes & Variations',productDataUploader),
                buildCheckBox('Product Categories', categoriesRelationshipUploader),
                const SizedBox(height: TSizes.spaceBtwItems),
                const Text('Sit Tight, Your product is uploading...')
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget buildCheckBox(String label, RxBool value) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: value.value ? const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.blue) : const Icon(CupertinoIcons.checkmark_alt_circle)
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(label)
      ],
    );
  }
}
