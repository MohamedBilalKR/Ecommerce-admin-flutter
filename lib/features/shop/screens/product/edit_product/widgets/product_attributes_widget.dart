import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:e_commerce_admin/common/widgets/images/t_rounded_image.dart';
import 'package:e_commerce_admin/features/shop/controllers/product/edit_product_controller.dart';
import 'package:e_commerce_admin/features/shop/models/product_model.dart';
import 'package:e_commerce_admin/utils/constants/colors.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:e_commerce_admin/utils/constants/image_strings.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:e_commerce_admin/utils/device/device_utility.dart';
import 'package:e_commerce_admin/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../controllers/product/product_attributes_controller.dart';
import '../../../../controllers/product/product_variations_controller.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final productController = EditProductController.instance;
    final attributeController = Get.put(ProductAttributesController());
    final variationController = Get.put(ProductVariationsController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return productController.productType.value == ProductType.single
              ? const Column(
                  children: [
                    Divider(color: TColors.primaryBackground),
                    SizedBox(height: TSizes.spaceBtwSections),
                  ],
                )
              : const SizedBox.shrink();
        }),

        Text('Add Product Attributes',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: TSizes.spaceBtwItems),

        //Form to add new Attributes
        Form(
          key: attributeController.attributesFormKey,
          child: TDeviceUtils.isDesktopScreen(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildAttributeName(attributeController),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      flex: 2,
                      child: _buildAddAttributeTextField(attributeController),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    _buildAddAttributeButton(attributeController),
                  ],
                )
              : Column(
                  children: [
                    _buildAttributeName(attributeController),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    _buildAddAttributeTextField(attributeController),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    _buildAddAttributeButton(attributeController),
                  ],
                ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        //List od added Attributes
        Text('All Attributes',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: TSizes.spaceBtwItems),

        //Display Added Attributes
        TRoundedContainer(
          backgroundColor: TColors.primaryBackground,
          child: Obx(
            () => attributeController.productAttributes.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    itemCount: attributeController.productAttributes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                    itemBuilder: (_, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: TColors.white,
                          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                        ),
                        child: ListTile(
                          title: Text(attributeController.productAttributes[index].name ?? ''),
                          subtitle: Text(attributeController.productAttributes[index].values!.map((e) => e.trim()).toString()),
                          trailing: IconButton(
                            onPressed: () => attributeController.removeAttribute(index, context),
                            icon: const Icon(Iconsax.trash, color: TColors.error),
                          ),
                        ),
                      );
                    },
                  )
                : const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TRoundedImage(
                            width: 150,
                            height: 150,
                            imageType: ImageType.asset,
                            image: TImages.defaultAttributeColorsImageIcon,
                          )
                        ],
                      ),
                      SizedBox(height: TSizes.spaceBtwItems),
                      Text('There are no attributes add for this product')
                    ],
                  ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        //Generate Variations Button
        Obx(
          () => productController.productType.value == ProductType.variable && variationController.productVariations.isEmpty 
          ? Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  icon: const Icon(Iconsax.activity),
                  label: const Text('Generate Variations'),
                  onPressed: () => variationController.generateVariationsConfirmation(context),
              ),
            ),
          ) : const SizedBox.shrink(),
        )
      ],
    );
  }

  TextFormField _buildAttributeName(ProductAttributesController controller) {
    return TextFormField(
      controller: controller.attributeName,
      validator: (value) =>
          TValidator.validateEmptyText('Attribute Name', value),
      decoration: const InputDecoration(
          labelText: 'Attribute Name', hintText: 'Colors, Sizes, Materials'),
    );
  }

  SizedBox _buildAddAttributeTextField(ProductAttributesController controller) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        expands: true,
        maxLines: null,
        textAlign: TextAlign.start,
        controller: controller.attributes,
        keyboardType: TextInputType.multiline,
        textAlignVertical: TextAlignVertical.top,
        validator: (value) =>
            TValidator.validateEmptyText('Attribute Field', value),
        decoration: const InputDecoration(
          labelText: 'Attributes',
          hintText: 'Add attributes seperated by | Exapmle: Green | Blue | Red',
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  SizedBox _buildAddAttributeButton(ProductAttributesController controller) {
    return SizedBox(
      width: 100,
      child: ElevatedButton.icon(
          onPressed: () => controller.addNewAttribute(),
          icon: const Icon(Iconsax.add),
          style: ElevatedButton.styleFrom(
            foregroundColor: TColors.black,
            backgroundColor: TColors.secondary,
            side: const BorderSide(color: TColors.secondary),
          ),
          label: const Text('Add')),
    );
  }

  // ListView buildAttributesList(BuildContext context) {
  //   return ListView.separated(
  //       shrinkWrap: true,
  //       itemCount: 3,
  //       separatorBuilder: (_, __) =>
  //           const SizedBox(height: TSizes.spaceBtwItems),
  //       itemBuilder: (_, index) {
  //         return Container(
  //           decoration: BoxDecoration(
  //             color: TColors.white,
  //             borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
  //           ),
  //           child: ListTile(
  //             title: const Text('Color'),
  //             subtitle: const Text('Green, Blue, Red'),
  //             trailing: IconButton(
  //                 onPressed: () {},
  //                 icon: const Icon(Iconsax.trash, color: TColors.error)),
  //           ),
  //         );
  //       });
  // }

  // Column buildEmptyAttributes() {
  //   return const Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           TRoundedImage(
  //               width: 150,
  //               height: 80,
  //               imageType: ImageType.asset,
  //               image: TImages.defaultAttributeColorsImageIcon),
  //         ],
  //       ),
  //       SizedBox(height: TSizes.spaceBtwItems),
  //       Text('There are no attributes added for this product'),
  //     ],
  //   );
  // }
}
