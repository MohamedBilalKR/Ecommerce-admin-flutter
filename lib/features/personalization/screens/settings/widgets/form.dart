import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/settings_controller.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;

    return Column(
      children: [
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(
              vertical: TSizes.lg, horizontal: TSizes.md),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('App Settings',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: TSizes.spaceBtwSections),

                //App Name
                TextFormField(
                  controller: controller.appNameController,
                  decoration: const InputDecoration(
                      hintText: 'App Name',
                      label: Text('App Name'),
                      prefixIcon: Icon(Iconsax.shop)),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                //Email and Phone
                Row(
                  children: [
                    //Tax
                    Expanded(
                      child: TextFormField(
                        controller: controller.taxController,
                        decoration: const InputDecoration(
                          hintText: 'Tax %',
                          label: Text('Tax rate (%)'),
                          prefixIcon: Icon(Iconsax.tag),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),

                    //Shipping Cost
                    Expanded(
                      child: TextFormField(
                        controller: controller.shippingController,
                        decoration: const InputDecoration(
                          hintText: 'Shipping Cost',
                          label: Text('Shipping Cost (₹)'),
                          prefixIcon: Icon(Iconsax.ship),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),

                    //Free Shipping
                    Expanded(
                      child: TextFormField(
                        controller: controller.freeShippingController,
                        decoration: const InputDecoration(
                          hintText: 'Free Shipping After (₹)',
                          label: Text('Free Shipping Threshold (₹)'),
                          prefixIcon: Icon(Iconsax.ship),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                        onPressed: () => controller.loading.value
                            ? () {}
                            : controller.updateSettingInformation(),
                        child: controller.loading.value
                            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            : const Text('Update App Settings')),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
