import 'package:e_commerce_admin/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:e_commerce_admin/features/shop/models/order_model.dart';
import 'package:e_commerce_admin/routes/routes.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../widgets/customer_info.dart';
import '../widgets/order_info.dart';
import '../widgets/order_items.dart';
import '../widgets/order_transaction.dart';

class OrderDetailsDesktopScreen extends StatelessWidget {
  const OrderDetailsDesktopScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //BreadCrumbs
              BreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: order.id,
                breadcrumbItems: const [Routes.orders, 'Details'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Left Side Order Information
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        //Order Info
                        OrderInfo(order: order),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Items
                        OrderItems(order: order),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Transaction
                        OrderTransaction(order: order),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwSections),

                  //Right Side
                  Expanded(
                    child: Column(
                      children: [
                        //Customer Info
                        OrderCustomer(order: order),
                        const SizedBox(width: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
