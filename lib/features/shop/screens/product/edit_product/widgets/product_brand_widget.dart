import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:e_commerce_admin/features/shop/models/product_model.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../controllers/brand/brand_controller.dart';
import '../../../../controllers/product/edit_product_controller.dart';

class ProductBrand extends StatelessWidget {
  const ProductBrand({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProductController());
    final brandController = Get.put(BrandController());

    // Fetch brands if list is empty
    if (brandController.allItems.isEmpty) {
      brandController.fetchItems();
    }

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Label
          Text('Brand', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),

          // TypeAheadField for Brand Selection
          Obx(() => brandController.isLoading.value
              ? const TShimmerEffect(width: double.infinity, height: 50)
              : TypeAheadField(
                  builder: (context, ctr, focusNode) {
                    ctr.text = controller.brandTextField.text;
                    return TextFormField(
                      focusNode: focusNode,
                      controller: controller.brandTextField = ctr,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Brand',
                        suffixIcon: Icon(Iconsax.box),
                      ),
                    );
                  },
                  suggestionsCallback: (pattern) {
                    return brandController.allItems
                        .where((brand) => brand.name.contains(pattern))
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.name),
                    );
                  },
                  onSelected: (suggestion) {
                    controller.selectedBrand.value = suggestion;
                    controller.brandTextField.text = suggestion.name;
                  },
                )),
        ],
      ),
    );
  }
}

