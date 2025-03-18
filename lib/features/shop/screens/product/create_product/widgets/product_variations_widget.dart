import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:e_commerce_admin/common/widgets/images/image_uploader.dart';
import 'package:e_commerce_admin/common/widgets/images/t_rounded_image.dart';
import 'package:e_commerce_admin/features/shop/controllers/product/create_product_controller.dart';
import 'package:e_commerce_admin/features/shop/controllers/product/product_images_controller.dart';
import 'package:e_commerce_admin/features/shop/controllers/product/product_variations_controller.dart';
import 'package:e_commerce_admin/features/shop/models/product_variation_model.dart';
import 'package:e_commerce_admin/utils/constants/colors.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:e_commerce_admin/utils/constants/image_strings.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductVariations extends StatelessWidget {
  const ProductVariations({super.key});

  @override
  Widget build(BuildContext context) {
    final variationController = ProductVariationsController.instance;

    return Obx(
      () => CreateProductController.instance.productType.value == ProductType.variable
          ? TRoundedContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Product Variations Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Product Variations',
                          style: Theme.of(context).textTheme.headlineSmall),
                      TextButton(
                          onPressed: () => variationController.removeVariations(context),
                          child: const Text('Remove Variations')),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  //Variation List
                  if (variationController.productVariations.isNotEmpty)
                  ListView.separated(
                    itemCount: variationController.productVariations.length,
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                    itemBuilder: (_, index) {
                      final variation = variationController.productVariations[index];
                      return _buildVariationTile(context, index, variation, variationController);
                    },
                  )
                  else
                  //No Variation Message
                  _buildNoVariationsMessage()
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildVariationTile(BuildContext context, int index, ProductVariationModel variation, ProductVariationsController variationController) {
    return ExpansionTile(
      backgroundColor: TColors.lightGrey,
      collapsedBackgroundColor: TColors.lightGrey,
      childrenPadding: const EdgeInsets.all(TSizes.md),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.borderRadiusLg)),
      title: Text(variation.attributeValues.entries.map((entry) => '${entry.key} : ${entry.value}').join(', ')),
      children: [
        Obx(
          () => TImageUploader(
            right: 0,
            left: null,
            imageType: variation.image.value.isNotEmpty ? ImageType.network : ImageType.asset,
            image: variation.image.value.isNotEmpty ? variation.image.value : TImages.defaultImage,
            onIconButtonPressed: () => ProductImagesController.instance.selectVariationImage(variation),
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        //Variation Stock and Pricing
        Row(
          children: [
            //Stock
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) => variation.stock = int.parse(value),
                controller: variationController.stockControllersList[index][variation],
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Stock', hintText: 'Add Stock, Only numbers are allowed')
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwInputFields),

            //Price
            Expanded(
              child: TextFormField(
                keyboardType:const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => variation.price = double.parse(value),
                controller: variationController.priceControllersList[index][variation],
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$'))],
                decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: 'Price with up-to 2 Decimals'),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwInputFields),

            //Sale Price
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Sale Price',
                    hintText: 'Price with up-to 2 Decimals'),
                keyboardType:const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => variation.salePrice = double.parse(value),
                controller: variationController.salePriceControllersList[index][variation],
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}$'),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),

        //Variation Description
        TextFormField(
          onChanged: (value) => variation.description = value,
          controller: variationController.descriptionControllersList[index][variation],
          decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Add description of this variation...'),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
      ],
    );
  }

  Widget _buildNoVariationsMessage() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TRoundedImage(
              width: 200,
              height: 200,
              imageType: ImageType.asset,
              image: TImages.defaultVariationImageIcon,
            )
          ],
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Text('There are no Variations added for this product'),
      ],
    );
  }
}
