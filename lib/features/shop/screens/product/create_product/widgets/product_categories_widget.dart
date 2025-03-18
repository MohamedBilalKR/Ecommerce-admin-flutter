import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:e_commerce_admin/common/widgets/shimmers/shimmer.dart';
import 'package:e_commerce_admin/features/shop/controllers/category/category_controller.dart';
import 'package:e_commerce_admin/features/shop/controllers/product/create_product_controller.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../../../utils/constants/sizes.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());

    if (categoryController.allItems.isEmpty) {
      categoryController.fetchItems();
    }

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Categories Label
          Text('Categories', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),

          //MultiSelect
          Obx(
            () => categoryController.isLoading.value
                ? const TShimmerEffect(width: double.infinity, height: 50)
                : MultiSelectDialogField(
                    buttonText: const Text('Select Categories'),
                    title: const Text('Categories'),
                    items: categoryController.allItems.map((category) => MultiSelectItem(category, category.name)).toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (values) {
                      CreateProductController.instance.selectedCategories.assignAll(values);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
