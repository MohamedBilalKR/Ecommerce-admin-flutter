import 'package:e_commerce_admin/features/shop/models/product_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
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

class EditProductDesktopScreen extends StatelessWidget {
  const EditProductDesktopScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductImagesController.instance;

    return Scaffold(
      bottomNavigationBar: ProductBottomNavigationButtons(product: product),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //BreadCrumbs
              const BreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Edit Product',
                  breadcrumbItems: [Routes.products, 'Edit Product']),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Create Product
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: TDeviceUtils.isTabletScreen(context) ? 2 : 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Basic Information
                        ProductTitleAndDescription(product: product),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Stock & Pricing
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //HEading
                              Text('Stock & Pricing',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              const SizedBox(height: TSizes.spaceBtwItems),

                              //Product Type
                              ProductTypeWidget(product: product),
                              const SizedBox(
                                  height: TSizes.spaceBtwInputFields),

                              //Stock
                              ProductStockAndPricing(product: product),
                              const SizedBox(height: TSizes.spaceBtwSections),

                              //Attribute
                              ProductAttributes(product: product),
                              const SizedBox(height: TSizes.spaceBtwSections),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Variation
                        ProductVariations(product: product),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.defaultSpace),

                  //Sidebar
                  Expanded(
                    child: Column(
                      children: [
                        //Product Thumbnail
                        ProductThumbnailImage(product: product),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Product Image
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('All Product Images',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
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
                        ProductBrand(product: product),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Product Categories
                        ProductCategories(product: product),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
