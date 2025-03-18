import 'package:e_commerce_admin/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:e_commerce_admin/common/widgets/loaders/loader_animation.dart';
import 'package:e_commerce_admin/features/shop/controllers/category/category_controller.dart';
import 'package:e_commerce_admin/routes/routes.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../table/data_table.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';

class CategoriesDesktopScreen extends StatelessWidget {
  const CategoriesDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //BreadCrumbs
              const BreadcrumbsWithHeading(
                  heading: 'Categories', breadcrumbItems: ['Categories']),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Table Body

              //Show Loader
              TRoundedContainer(
                child: Column(
                  children: [
                    //Table Header
                    TableHeader(
                      buttonText: 'Create New Category',
                      onPressed: () => Get.toNamed(Routes.createCategory),
                      searchController: controller.searchTextController,
                      searchOnChanged: (query) => controller.searchQuery(query),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    //Table
                    Obx(
                      () {
                        if (controller.isLoading.value) return const TLoaderAnimation();
                        return const CategoryTable();
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
