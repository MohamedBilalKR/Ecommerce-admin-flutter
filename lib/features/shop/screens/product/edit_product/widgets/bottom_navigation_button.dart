import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:e_commerce_admin/features/shop/controllers/product/edit_product_controller.dart';
import 'package:e_commerce_admin/features/shop/models/product_model.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProductBottomNavigationButtons extends StatelessWidget {
  const ProductBottomNavigationButtons({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //Discard Button
          OutlinedButton(onPressed: () {}, child: const Text('Discard')),
          const SizedBox(width: TSizes.spaceBtwItems / 2),

          //Save Button
          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: () =>
                  EditProductController.instance.editProduct(product),
              child: const Text('Update Changes'),
            ),
          )
        ],
      ),
    );
  }
}
