import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:e_commerce_admin/common/widgets/shimmers/shimmer.dart';
import 'package:e_commerce_admin/features/shop/controllers/order/order_controller.dart';
import 'package:e_commerce_admin/features/shop/models/order_model.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:e_commerce_admin/utils/device/device_utility.dart';
import 'package:e_commerce_admin/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    controller.orderStatus.value = order.status;

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Information',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),

          //Personal Info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date'),
                    Text(order.formattedOrderDate,
                        style: Theme.of(context).textTheme.bodyLarge)
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Items'),
                    Text('${order.items.length} Items',
                        style: Theme.of(context).textTheme.bodyLarge)
                  ],
                ),
              ),
              Expanded(
                flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status'),
                    Obx(() {
                      if (controller.statusLoader.value) return const TShimmerEffect(width: 150, height: 55);
                      return TRoundedContainer(
                        radius: TSizes.cardRadiusMd,
                        padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.sm, vertical: 0),
                        backgroundColor:
                            THelperFunctions.getOrderStatusColor(controller.orderStatus.value)
                                .withOpacity(0.1),
                        child: DropdownButton<OrderStatus>(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            value: controller.orderStatus.value,
                            onChanged: (OrderStatus? newValue) {
                              if (newValue != null) {
                                controller.updateOrderStatus(order, newValue);
                              }
                            },
                            items: OrderStatus.values.map((OrderStatus status) {
                              return DropdownMenuItem<OrderStatus>(
                                value: status,
                                child: Text(
                                  status.name.capitalize.toString(),
                                  style: TextStyle(
                                    color: THelperFunctions.getOrderStatusColor(controller.orderStatus.value),
                                  ),
                                ),
                              );
                            }).toList()),
                      );
                    })
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total'),
                    Text('₹${order.totalAmount}',
                        style: Theme.of(context).textTheme.bodyLarge)
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
