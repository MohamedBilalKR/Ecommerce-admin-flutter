import 'package:e_commerce_admin/features/shop/models/product_model.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/product/edit_product_controller.dart';

class ProductTypeWidget extends StatelessWidget {
  const ProductTypeWidget({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = EditProductController.instance;

    return Obx(
      () => Row(
        children: [
          Text('Product Type', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: TSizes.spaceBtwItems),
      
          //Radio Button
          RadioMenuButton(
              value: ProductType.single,
              groupValue: controller.productType.value,
              onChanged: (value) {
                controller.productType.value = value ?? ProductType.single;
              },
              child: const Text('Single')),
          RadioMenuButton(
              value: ProductType.variable,
              groupValue: controller.productType.value,
              onChanged: (value) {
                controller.productType.value = value ?? ProductType.single;
              },
              child: const Text('Variable')),
        ],
      ),
    );
  }
}
