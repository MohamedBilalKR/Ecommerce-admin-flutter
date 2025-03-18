import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:e_commerce_admin/features/shop/controllers/category/category_controller.dart';  
import 'package:e_commerce_admin/features/shop/controllers/product/edit_product_controller.dart';
import 'package:e_commerce_admin/features/shop/models/category_model.dart';
import 'package:e_commerce_admin/features/shop/models/product_model.dart';
import 'package:e_commerce_admin/utils/helpers/cloud_helper_functions.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../../../utils/constants/sizes.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final productController = EditProductController.instance;

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Categories Label
          Text('Categories', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),

          FutureBuilder(
            future: productController.loadSelectedCategories(product.id),
            builder: (context, snapshot) {
              final widget = TCloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot);
              if (widget != null) return widget;

              //MultiSelect
              return MultiSelectDialogField(
                buttonText: const Text('Select Categories'),
                title: const Text('Categories'),
                initialValue: List<CategoryModel>.from(
                    productController.selectedCategories),
                items: CategoryController.instance.allItems
                    .map((category) => MultiSelectItem(category, category.name))
                    .toList(),
                listType: MultiSelectListType.CHIP,
                onConfirm: (values) {
                  productController.selectedCategories.assignAll(values);
                },
              );
            },
          )
        ],
      ),
    );
  }
}
