import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:e_commerce_admin/common/widgets/images/image_uploader.dart';
import 'package:e_commerce_admin/common/widgets/shimmers/shimmer.dart';
import 'package:e_commerce_admin/features/shop/controllers/category/create_category_controller.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:e_commerce_admin/utils/constants/image_strings.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:e_commerce_admin/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../controllers/category/category_controller.dart';

class CreateCategoryForm extends StatelessWidget {
  const CreateCategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateCategoryController());
    final categoryController = Get.put(CategoryController());

    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: createController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Heading
            const SizedBox(height: TSizes.sm),
            Text('Create New Category',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            //Name
            TextFormField(
              controller: createController.name,
              validator: (value) => TValidator.validateEmptyText('Name', value),
              decoration: const InputDecoration(
                  labelText: 'Category Name',
                  prefixIcon: Icon(Iconsax.category)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            //Catergories DropDown
            Obx(
              () => categoryController.isLoading.value
                  ? const TShimmerEffect(width: double.infinity, height: 55)
                  : DropdownButtonFormField(
                      decoration: const InputDecoration(
                          hintText: 'Parent Category',
                          labelText: 'Parent Category',
                          prefixIcon: Icon(Iconsax.bezier)),
                      onChanged: (newValue) =>
                          createController.selectedParent.value = newValue!,
                      items: categoryController.allItems
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [Text(item.name)]),
                              ))
                          .toList(),
                    ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Thumbnail image
                Column(
                  children: [
                    Text('Thumbnail Image',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Obx(
                      () => TImageUploader(
                        width: 80,
                        height: 80,
                        image: createController.imageURL.value.isNotEmpty
                            ? createController.imageURL.value
                            : TImages.defaultImage,
                        imageType: createController.imageURL.value.isNotEmpty
                            ? ImageType.network
                            : ImageType.asset,
                        onIconButtonPressed: () =>
                            createController.pickImageThumbnail(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: TSizes.spaceBtwItems),

                //Banner Image
                Column(
                  children: [
                    Text('Banner Image',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Obx(
                      () => TImageUploader(
                        width: 160,
                        height: 80,
                        image: createController.banner.value.isNotEmpty
                            ? createController.banner.value
                            : TImages.defaultImage,
                        imageType: createController.banner.value.isNotEmpty
                            ? ImageType.network
                            : ImageType.asset,
                        onIconButtonPressed: () =>
                            createController.pickImageBanner(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            Obx(
              () => CheckboxMenuButton(
                value: createController.isFeatured.value,
                onChanged: (value) =>
                    createController.isFeatured.value = value ?? false,
                child: const Text('Featured'),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => createController.createCategory(),
                  child: const Text('Create')),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2)
          ],
        ),
      ),
    );
  }
}
