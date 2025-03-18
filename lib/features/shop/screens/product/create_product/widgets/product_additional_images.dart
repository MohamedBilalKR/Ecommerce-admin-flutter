import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:e_commerce_admin/common/widgets/images/image_uploader.dart';
import 'package:e_commerce_admin/utils/constants/colors.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:e_commerce_admin/utils/constants/image_strings.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProductAdditionalImages extends StatelessWidget {
  const ProductAdditionalImages(
      {super.key,
      required this.additionalProductImagesURLs,
      this.onTapToAddImages,
      this.onTapToRemoveImages});

  final RxList<String> additionalProductImagesURLs;
  final void Function()? onTapToAddImages;
  final void Function(int index)? onTapToRemoveImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          //Section to add additional product image
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onTapToAddImages,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(TImages.defaultMultiImageIcon,
                        width: 50, height: 50),
                    const Text('Add Additional Product Images'),
                  ],
                ),
              ),
            ),
          ),

          //Section to Display Uploaded Images
          Expanded(
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: SizedBox(
                        height: 80, child: Obx(() => _uploadImagesOrEmptyList()))),
                const SizedBox(width: TSizes.spaceBtwItems / 2),

                //Add More Image Button
                TRoundedContainer(
                  width: 80,
                  height: 80,
                  showBorder: true,
                  borderColor: TColors.grey,
                  backgroundColor: TColors.white,
                  onTap: onTapToAddImages,
                  child: const Center(child: Icon(Iconsax.add)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _uploadImagesOrEmptyList() {
    return additionalProductImagesURLs.isNotEmpty ? _uploadedImages() : emptyList();
  }

  Widget emptyList() {
    return ListView.separated(
      itemCount: 6,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) =>
          const SizedBox(width: TSizes.spaceBtwItems / 2),
      itemBuilder: (context, index) => const TRoundedContainer(
          backgroundColor: TColors.primaryBackground, width: 80, height: 80),
    );
  }

  //Widget to Display Uploaded Images
  ListView _uploadedImages() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: additionalProductImagesURLs.length,
      separatorBuilder: (context, index) =>
          const SizedBox(width: TSizes.spaceBtwItems / 2),
      itemBuilder: (context, index) {
        final image = additionalProductImagesURLs[index];
        return TImageUploader(
          top: 0,
          right: 0,
          width: 80,
          height: 80,
          left: null,
          bottom: null,
          image: image,
          icon: Iconsax.trash,
          imageType: ImageType.network,
          onIconButtonPressed: () => onTapToRemoveImages!(index),
        );
      },
    );
  }
}
