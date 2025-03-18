import 'package:e_commerce_admin/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:e_commerce_admin/features/media/screens/media/widgets/media_content.dart';
import 'package:e_commerce_admin/features/media/screens/media/widgets/media_uploader.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/media_controller.dart';

class MediaDesktopScreen extends StatelessWidget {
  const MediaDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Breadcrumbs
                  const BreadcrumbsWithHeading(
                      heading: 'Media', breadcrumbItems: ['Media Screen']),

                  SizedBox(
                    width: TSizes.buttonWidth * 1.5,
                    child: ElevatedButton.icon(
                      onPressed: () => controller.showImagesUploaderSection
                          .value = !controller.showImagesUploaderSection.value,
                      icon: const Icon(Iconsax.cloud_add),
                      label: const Text('Upload Image'),
                    ),
                  )
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Upload Area
              const MediaUploader(),

              //Media
              MediaContent(
                  allowSelection: false, allowMultipleSelection: false),
            ],
          ),
        ),
      ),
    );
  }
}
