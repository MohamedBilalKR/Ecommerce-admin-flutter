import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../widgets/bottom_navigation_button.dart';
import '../widgets/product_additional_images.dart';
import '../widgets/product_attributes_widget.dart';
import '../widgets/product_brand_widget.dart';
import '../widgets/product_categories_widget.dart';
import '../widgets/product_thumbnail_widget.dart';
import '../widgets/product_type_widget.dart';
import '../widgets/product_variations_widget.dart';
import '../widgets/stock_pricing_widget.dart';
import '../widgets/title_description.dart';

class CreateProductMobileScreen extends StatelessWidget {
  const CreateProductMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImagesController());

    return Scaffold(
      bottomNavigationBar: const ProductBottomNavigationButtons(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //BreadCrumbs
              const BreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Add Product',
                  breadcrumbItems: [Routes.products, 'Add Product']),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Create Product
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Basic Information
                  const ProductTitleAndDescription(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  //Stock & Pricing
                  TRoundedContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //HEading
                        Text('Stock & Pricing',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: TSizes.spaceBtwItems),

                        //Product Type
                        const ProductTypeWidget(),
                        const SizedBox(height: TSizes.spaceBtwInputFields),

                        //Stock
                        const ProductStockAndPricing(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Attribute
                        const ProductAttributes(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  //Variation
                  const ProductVariations(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  //Product Thumbnail
                  const ProductThumbnailImage(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  //Product Image
                  TRoundedContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All Product Images',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        ProductAdditionalImages(
                          additionalProductImagesURLs:
                              controller.additionalProductImagesUrls,
                          onTapToAddImages: () =>
                              controller.selectMultipleProductImage(),
                          onTapToRemoveImages: (index) =>
                              controller.removeImage(index),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  //Product Brand
                  const ProductBrand(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  //Product Categories
                  const ProductCategories(),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
