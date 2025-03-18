import 'package:e_commerce_admin/features/shop/controllers/product/product_attributes_controller.dart';
import 'package:e_commerce_admin/utils/popups/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_variation_model.dart';

class ProductVariationsController extends GetxController {
  static ProductVariationsController get instance => Get.find();

  final isLoading = false.obs;
  final RxList<ProductVariationModel> productVariations = <ProductVariationModel>[].obs;

  //Lists to store controllers for each variations attributes
  List<Map<ProductVariationModel, TextEditingController>> stockControllersList = [];
  List<Map<ProductVariationModel, TextEditingController>> priceControllersList = [];
  List<Map<ProductVariationModel, TextEditingController>> salePriceControllersList = [];
  List<Map<ProductVariationModel, TextEditingController>> descriptionControllersList = [];

  final attributeController = Get.put(ProductAttributesController());

  void initializeVariationsControllers(List<ProductVariationModel> variations) {
  stockControllersList.clear();
  priceControllersList.clear();
  salePriceControllersList.clear();
  descriptionControllersList.clear();

  for (var variation in variations) {
    // Stock Controllers
    stockControllersList.add({variation: TextEditingController(text: variation.stock.toString())});

    // Price Controllers
    priceControllersList.add({variation: TextEditingController(text: variation.price.toString())});

    // Sale Price Controllers
    salePriceControllersList.add({variation: TextEditingController(text: variation.salePrice.toString())});

    // Description Controllers (✅ Fix: Prevent "null" as text)
    descriptionControllersList.add({variation: TextEditingController(text: variation.description ?? '')});
  }
}


  //Function to remove variations
  void removeVariations(BuildContext context) {
    TDialogs.defaultDialog(
      context: context,
      title: 'Remove Variations',
      onConfirm: () {
        productVariations.value = [];
        resetAllValues();
        Navigator.of(context).pop();
      }
    );
  }

  //Generate variations confirmation
  void generateVariationsConfirmation(BuildContext context) {
    TDialogs.defaultDialog(
      context: context,
      confirmText: 'Generate',
      title: 'Generate Variations',
      content: 'Once the variations are created, you cannot add more attributes. In order to add more attributes, you have yo delete any of the attributes',
      onConfirm: () => generateVariationsFromAttributes(),
    );
  }

  //Generate variations Function
  void generateVariationsFromAttributes() {
    //Close the popup
    Get.back();

    final List<ProductVariationModel> variations = [];

    if (attributeController.productAttributes.isNotEmpty) {
      final List<List<String>> attributeCombinations = getCombinations(attributeController.productAttributes.map((attr) => attr.values ?? <String>[]).toList());

      for (final combination in attributeCombinations) {
        final Map<String, String> attributesValues = Map.fromIterables(attributeController.productAttributes.map((attr) => attr.name ?? ''), combination);

        final ProductVariationModel variation = ProductVariationModel(id: UniqueKey().toString(), attributeValues: attributesValues);

        variations.add(variation);

        //Create Controllers
        final Map<ProductVariationModel, TextEditingController> stockControllers = {};
        final Map<ProductVariationModel, TextEditingController> priceControllers = {};
        final Map<ProductVariationModel, TextEditingController> salePriceControllers = {};
        final Map<ProductVariationModel, TextEditingController> descriptionControllers = {};

        // Assuming variation is your current VariationModel
        stockControllers[variation] = TextEditingController();
        priceControllers[variation] = TextEditingController();
        salePriceControllers[variation] = TextEditingController();
        descriptionControllers[variation] = TextEditingController();

        //Add the maps to lists
        stockControllersList.add(stockControllers);
        priceControllersList.add(priceControllers);
        salePriceControllersList.add(salePriceControllers);
        descriptionControllersList.add(descriptionControllers);
      }
    }

    productVariations.assignAll(variations);
  }

  //Get All combinations
  List<List<String>> getCombinations(List<List<String>> lists) {
    final List<List<String>> result = [];
    combine(lists, 0, <String>[], result);
    return result;
  }

  //Function to Combine
  void combine(List<List<String>> lists, int index, List<String> current, List<List<String>> result) {
    if (index == lists.length) {
      result.add(List.from(current));
      return;
    }

    for (final item in lists[index]) {
      final List<String> updated = List.from(current)..add(item);
      combine(lists, index + 1, updated, result);
    }
  }

  void resetAllValues() {
    productVariations.clear();
    stockControllersList.clear();
    priceControllersList.clear();
    salePriceControllersList.clear();
    descriptionControllersList.clear();
  }
}
