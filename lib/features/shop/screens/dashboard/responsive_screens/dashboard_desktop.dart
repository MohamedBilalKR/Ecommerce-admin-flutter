import 'package:e_commerce_admin/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:e_commerce_admin/features/shop/screens/dashboard/table/data_table.dart';
import 'package:e_commerce_admin/features/shop/screens/dashboard/widgets/order_status_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/icons/title_icon.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/weekly_sales.dart';

class DashboardScreenDesktop extends StatelessWidget {
  const DashboardScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Heading
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Card
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => DashboardCard(
                        stats: 25,
                        titleIcon: Iconsax.note,
                        titleIconColor: Colors.blue,
                        title: 'Sales Total',
                        subTitle:
                            '₹${controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount).toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => DashboardCard(
                        stats: 15,
                        titleIcon: Iconsax.external_drive,
                        titleIconColor: Colors.green,
                        title: 'Average Order Value',
                        subTitle:
                            '₹${(controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount) / controller.orderController.allItems.length).toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => DashboardCard(
                        stats: 52,
                        titleIcon: Iconsax.box,
                        titleIconColor: Colors.purple,
                        title: 'Total Orders',
                        subTitle:
                            '${controller.orderController.allItems.length}',
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => DashboardCard(
                        stats: 18,
                        titleIcon: Iconsax.user,
                        titleIconColor: Colors.orange,
                        title: 'Visitors',
                        subTitle: controller.customerController.allItems.length.toString(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Graph
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        //Bar Graph
                        const WeeklySalesGraph(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Orders
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const TitleIcon(
                                      icon: Iconsax.box, color: Colors.purple),
                                  const SizedBox(
                                      width: TSizes.spaceBtwItems / 2),
                                  Text('Recent Orders',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall),
                                ],
                              ),
                              const SizedBox(height: TSizes.spaceBtwSections),
                              const DashboardOrderTable(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwSections),

                  //Pie chart
                  const Expanded(child: OrderStatusPieChart()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
