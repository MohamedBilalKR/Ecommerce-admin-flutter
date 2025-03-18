import 'package:e_commerce_admin/common/widgets/loaders/loader_animation.dart';
import 'package:e_commerce_admin/features/shop/controllers/brand/brand_controller.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../routes/routes.dart';
import '../table/data_table.dart';

class BrandsDesktopScreen extends StatelessWidget {
  const BrandsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //BreadCrumbs
              const BreadcrumbsWithHeading(
                  heading: 'Brands', breadcrumbItems: ['Brands']),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Table Body
              //Show Loader
              TRoundedContainer(
                child: Column(
                  children: [
                    //Table Header
                    TableHeader(
                      buttonText: 'Add New Brand',
                      onPressed: () => Get.toNamed(Routes.createBrand),
                      searchOnChanged: (query) => controller.searchQuery(query),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    //Table
                    Obx(
                      () {
                        //Show Loader
                        if (controller.isLoading.value)
                          return const TLoaderAnimation();
                        return const BrandTable();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
