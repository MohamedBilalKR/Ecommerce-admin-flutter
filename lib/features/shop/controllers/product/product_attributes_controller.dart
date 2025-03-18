import 'package:e_commerce_admin/features/shop/models/product_attribute_model.dart';
import 'package:e_commerce_admin/utils/popups/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'product_variations_controller.dart';

class ProductAttributesController extends GetxController {
  static ProductAttributesController get instance => Get.find();

  //Observable for loading
  final isLoading = false.obs;

  //Controllers and Keys
  final attributesFormKey = GlobalKey<FormState>();

  //Text Editing Controllers
  TextEditingController attributeName = TextEditingController();
  TextEditingController attributes = TextEditingController();

  //Observables
  final RxList<ProductAttributeModel> productAttributes = <ProductAttributeModel>[].obs;

  //Function to add new attributes
  void addNewAttribute() {
    //Form Validation
    if (!attributesFormKey.currentState!.validate()) {
      return;
    }

    productAttributes.add(ProductAttributeModel(
        name: attributeName.text.trim(),
        values: attributes.text.trim().split('|').toList()));

    //Clear Textfields
    attributeName.text = '';
    attributes.text = '';
  }

  //Function to Remove attribuites
  void removeAttribute(int index, BuildContext context) {
    TDialogs.defaultDialog(
      context: context,
      onConfirm: () {
        Navigator.of(context).pop();
        productAttributes.removeAt(index);

        ProductVariationsController.instance.productVariations.value = [];
      },
    );
  }

  void resetProductAttributes() {
    productAttributes.clear();
  }
}
