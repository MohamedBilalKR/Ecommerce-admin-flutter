import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../controllers/category/edit_category_controller.dart';
import '../../../../models/category_model.dart';

class EditCategoryForm extends StatelessWidget {
  const EditCategoryForm({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditCategoryController());
    editController.init(category);
    final categoryController = Get.put(CategoryController());

    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: editController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: TSizes.sm),
            Text('Update Category',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Name
            TextFormField(
              controller: editController.name,
              validator: (value) => TValidator.validateEmptyText('Name', value),
              decoration: const InputDecoration(
                  labelText: 'Category Name',
                  prefixIcon: Icon(Iconsax.category)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Categories DropDown
            Obx(
              () => categoryController.isLoading.value
                  ? const TShimmerEffect(width: double.infinity, height: 55)
                  : DropdownButtonFormField<CategoryModel?>(
                      decoration: const InputDecoration(
                          hintText: 'Parent Category',
                          labelText: 'Parent Category',
                          prefixIcon: Icon(Iconsax.bezier)),
                      value: editController.selectedParent.value.id.isNotEmpty
                          ? editController.selectedParent.value
                          : null,
                      onChanged: (newValue) {
                        if (newValue == null) {
                          // Set an empty category model when "No Parent" is selected
                          editController.selectedParent.value =
                              CategoryModel.empty();
                        } else {
                          editController.selectedParent.value = newValue;
                        }
                      },
                      items: [
                        const DropdownMenuItem<CategoryModel?>(
                          value: null,
                          child: Text("No Parent"),
                        ),
                        ...categoryController.allItems.map(
                          (item) => DropdownMenuItem<CategoryModel>(
                            value: item,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [Text(item.name)],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // Thumbnail Image
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Thumbnail Image',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Obx(
                      () => TImageUploader(
                        width: 80,
                        height: 80,
                        image: editController.imageURL.value.isNotEmpty
                            ? editController.imageURL.value
                            : TImages.defaultImage,
                        imageType: editController.imageURL.value.isNotEmpty
                            ? ImageType.network
                            : ImageType.asset,
                        onIconButtonPressed: () =>
                            editController.pickImageThumbnail(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: TSizes.spaceBtwItems),

                // Banner Image
                Column(
                  children: [
                    Text('Banner Image',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Obx(
                      () => TImageUploader(
                        width: 160,
                        height: 80,
                        image: editController.banner.value.isNotEmpty
                            ? editController.banner.value
                            : TImages.defaultImage,
                        imageType: editController.banner.value.isNotEmpty
                            ? ImageType.network
                            : ImageType.asset,
                        onIconButtonPressed: () =>
                            editController.pickImageBanner(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Featured Checkbox
            Obx(
              () => CheckboxMenuButton(
                value: editController.isFeatured.value,
                onChanged: (value) =>
                    editController.isFeatured.value = value ?? false,
                child: const Text('Featured'),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => editController.updateCategory(category),
                  child: const Text('Update')),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2)
          ],
        ),
      ),
    );
  }
}
