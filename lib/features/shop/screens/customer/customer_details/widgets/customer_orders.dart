import 'package:e_commerce_admin/common/widgets/loaders/animation_loader.dart';
import 'package:e_commerce_admin/common/widgets/loaders/loader_animation.dart';
import 'package:e_commerce_admin/utils/constants/colors.dart';
import 'package:e_commerce_admin/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/customer/customer_details_controller.dart';
import '../table/data_table.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerDetailsController.instance;
    controller.getCustomerOrders();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Obx(
        () {
          if (controller.ordersLoading.value) return const TLoaderAnimation();
          if (controller.allCustomerOrders.isEmpty) {
            return TAnimationLoaderWidget(text: 'No Orders Found', animation: TImages.cartAnimation);
          }

          final totalAmount = controller.allCustomerOrders.fold(0.0, (previousValue, element) => previousValue + element.totalAmount);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Orders',
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'Total Spent '),
                        TextSpan(
                            text: '₹${totalAmount.toString()}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .apply(color: TColors.primary)),
                        TextSpan(
                            text: ' on ${controller.allCustomerOrders.length} Orders',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              TextFormField(
                controller: controller.searchTextController,
                onChanged: (query) => controller.searchQuery(query),
                decoration: const InputDecoration(
                    hintText: 'Search Orders',
                    prefixIcon: Icon(Iconsax.search_normal)),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              const CustomerOrderTable()
            ],
          );
        },
      ),
    );
  }
}
