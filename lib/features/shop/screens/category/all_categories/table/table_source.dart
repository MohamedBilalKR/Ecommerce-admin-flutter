import 'package:data_table_2/data_table_2.dart';
import 'package:e_commerce_admin/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:e_commerce_admin/common/widgets/images/t_rounded_image.dart';
import 'package:e_commerce_admin/features/shop/controllers/category/category_controller.dart';
import 'package:e_commerce_admin/routes/routes.dart';
import 'package:e_commerce_admin/utils/constants/colors.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/constants/image_strings.dart';

class CategoryRows extends DataTableSource {
  final controller = CategoryController.instance;

  @override
  DataRow? getRow(int index) {
    final category = controller.filteredItems[index];
    final parentcategory = controller.allItems.firstWhereOrNull((item) => item.id == category.parentId);

    return DataRow2(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              TRoundedImage(
                width: 50,
                height: 50,
                padding: TSizes.sm,
                image: category.image.isNotEmpty ? category.image : TImages.defaultImage,
                imageType: category.image.isNotEmpty ? ImageType.network : ImageType.asset,
                borderRadius: TSizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Text(
                  category.name,
                  style: Theme.of(Get.context!)
                      .textTheme
                      .bodyLarge!
                      .apply(color: TColors.primary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        DataCell(
          TRoundedImage(
            width: 140,
            height: 80,
            padding: TSizes.sm,
            image: category.banner!.isNotEmpty ? category.banner : TImages.defaultImage,
            imageType: category.banner!.isNotEmpty ? ImageType.network : ImageType.asset,
            borderRadius: TSizes.borderRadiusMd,
            backgroundColor: TColors.primaryBackground,
          ),
        ),
        DataCell(Text(parentcategory != null ? parentcategory.name : 'No Parent')),
        DataCell(category.isFeatured ? const Icon(Iconsax.heart5, color: TColors.primary) : const Icon(Iconsax.heart)),
        DataCell(Text(category.createdAt == null ? '' : category.formattedDate)),
        DataCell(
          TTableActionButtons(
            onEditPressed: () =>
                Get.toNamed(Routes.editCategory, arguments: category),
            onDeletePressed: () => controller.confirmAndDeleteItem(category),
          ),
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount => controller.selectedRows.where((selected) => selected).length;
}
