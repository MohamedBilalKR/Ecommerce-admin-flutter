import 'package:e_commerce_admin/data/repositories/product/product_repository.dart';
import 'package:e_commerce_admin/features/shop/controllers/category/category_controller.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProductController extends GetxController {
  static EditProductController get instance => Get.find();

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
  final List<CategoryModel> alreadyAddedCategories = <CategoryModel>[].obs;

  //Flags for tracking different tasks
  RxBool thumbnailUploader = true.obs;
  RxBool additionalImagesUploader = true.obs;
  RxBool productDataUploader = false.obs;
  RxBool categoriesRelationshipUploader = false.obs;

  RxBool selectedCategoriesLoader = false.obs;

  final imagesController = ProductImagesController.instance;

  void initProductData(ProductModel? product) {
    try {
      if (product == null) {
        if (kDebugMode) print("Product is null!");
        return;
      }

      isLoading.value = true;

      // Basic Information
      title.text = product.title;
      description.text = product.description ?? '';
      productType.value = product.productType == ProductType.single.toString()
          ? ProductType.single
          : ProductType.variable;

      // Stock & Pricing
      if (product.productType == ProductType.single.toString()) {
        stock.text = product.stock.toString();
        price.text = product.price.toString();
        salePrice.text = product.salePrice.toString();
      }

      // Product Brand
      if (product.brand != null) {
        selectedBrand.value = product.brand;
        brandTextField.value = TextEditingValue(text: product.brand!.name);
      } else {
        selectedBrand.value = null;
        brandTextField.value = const TextEditingValue(text: '');
      }

      // Product Thumbnail & Additional Images
      if (product.thumbnail.isNotEmpty) {
        imagesController.selectedThumbnailImageUrl.value = product.thumbnail;
      } else {
        imagesController.selectedThumbnailImageUrl.value = '';
      }

      if (product.images != null && product.images!.isNotEmpty) {
        imagesController.additionalProductImagesUrls.assignAll(product.images!);
      } else {
        imagesController.additionalProductImagesUrls.clear();
      }

      // Product Attributes & Variations
      if (product.productAttributes != null &&
          product.productAttributes!.isNotEmpty) {
        ProductAttributesController.instance.productAttributes
            .assignAll(product.productAttributes!);
      } else {
        ProductAttributesController.instance.productAttributes.clear();
      }

      if (product.productVariations != null &&
          product.productVariations!.isNotEmpty) {
        ProductVariationsController.instance.productVariations
            .assignAll(product.productVariations!);
        ProductVariationsController.instance
            .initializeVariationsControllers(product.productVariations!);
      } else {
        ProductVariationsController.instance.productVariations.clear();
      }

      isLoading.value = false;

      update();
    } catch (e) {
      if (kDebugMode) print("Error in initProductData: $e");
    }
  }

  //Load the Selected Categories
  Future<List<CategoryModel>> loadSelectedCategories(String productId) async {
    selectedCategoriesLoader.value = true;

    final productCategories =
        await ProductRepository.instance.getProductCategories(productId);
    final categoriesController = Get.put(CategoryController());
    if (categoriesController.allItems.isEmpty) {
      await categoriesController.fetchItems();
    }

    final categoriesIds = productCategories.map((e) => e.categoryId).toList();
    final categories = categoriesController.allItems
        .where((element) => categoriesIds.contains(element.id))
        .toList();
    selectedCategories.assignAll(categories);
    alreadyAddedCategories.assignAll(categories);
    selectedCategoriesLoader.value = false;
    return categories;
  }

  //Function to create Product
  Future<void> editProduct(ProductModel product) async {
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
      product.isFeatured = true;
      product.title = title.text.trim();
      product.brand = selectedBrand.value;
      product.description = description.text.trim();
      product.productType = productType.value.toString();
      product.stock = int.tryParse(stock.text.trim()) ?? 0;
      product.price = double.tryParse(price.text.trim()) ?? 0;
      product.salePrice = double.tryParse(salePrice.text.trim()) ?? 0;
      product.images = imagesController.additionalProductImagesUrls;
      product.thumbnail =
          imagesController.selectedThumbnailImageUrl.value ?? '';
      product.productAttributes =
          ProductAttributesController.instance.productAttributes;
      product.productVariations = variations;

      //Call Repository
      productDataUploader.value = true;
      await ProductRepository.instance.updateProduct(product);

      //Register Product Category
      if (selectedCategories.isNotEmpty) {
        categoriesRelationshipUploader.value = true;

        List<String> existingCategoryIds =
            alreadyAddedCategories.map((category) => category.id).toList();

        for (var category in selectedCategories) {
          if (!existingCategoryIds.contains(category.id)) {
            //Map Data
            final productCategory = ProductCategoryModel(
                productId: product.id, categoryId: category.id);
            await ProductRepository.instance
                .createProductCategory(productCategory);
          }
        }

        for (var existingCategoryId in existingCategoryIds) {
          if (!selectedCategories
              .any((category) => category.id == existingCategoryId)) {
            await ProductRepository.instance
                .removeProductCategory(product.id, existingCategoryId);
          }
        }
      }

      //Update Product List
      ProductController.instance.updateItemFromLists(product);

      //Stop Loader
      TFullScreenLoader.stopLoading();

      //Success Message
      shoeCompleteDialog();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
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
          const Text('Your Product has been Updated')
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
          title: const Text('Updating Product'),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(TImages.creatingProductIllustration,
                    height: 200, width: 200),
                const SizedBox(height: TSizes.spaceBtwItems),
                buildCheckBox('Thumbnail Image', thumbnailUploader),
                buildCheckBox('Additional Image', additionalImagesUploader),
                buildCheckBox('Product Data. Attributes & Variations',
                    productDataUploader),
                buildCheckBox(
                    'Product Categories', categoriesRelationshipUploader),
                const SizedBox(height: TSizes.spaceBtwItems),
                const Text('Sit Tight, Your product is Updating...')
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
            child: value.value
                ? const Icon(CupertinoIcons.checkmark_alt_circle_fill,
                    color: Colors.blue)
                : const Icon(CupertinoIcons.checkmark_alt_circle)),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(label)
      ],
    );
  }
}
