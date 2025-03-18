import 'package:e_commerce_admin/common/widgets/containers/circular_container.dart';
import 'package:e_commerce_admin/common/widgets/containers/rounded_container.dart';
import 'package:e_commerce_admin/common/widgets/loaders/loader_animation.dart';
import 'package:e_commerce_admin/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:e_commerce_admin/utils/constants/sizes.dart';
import 'package:e_commerce_admin/utils/device/device_utility.dart';
import 'package:e_commerce_admin/utils/helpers/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/icons/title_icon.dart';

class OrderStatusPieChart extends StatelessWidget {
  const OrderStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const TitleIcon(icon: Iconsax.status, color: Colors.red),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              Text('Order Status',
                  style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          //Chart
          Obx(
            () => controller.orderStatusData.isNotEmpty
                ? SizedBox(
                    height: 400,
                    child: PieChart(
                      PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius:
                              TDeviceUtils.isTabletScreen(context) ? 80 : 55,
                          startDegreeOffset: 180,
                          sections:
                              controller.orderStatusData.entries.map((entry) {
                            final OrderStatus status = entry.key;
                            final count = entry.value;

                            return PieChartSectionData(
                                showTitle: true,
                                color: THelperFunctions.getOrderStatusColor(
                                    status),
                                title: '$count',
                                value: count.toDouble(),
                                radius: TDeviceUtils.isTabletScreen(context)
                                    ? 80
                                    : 100,
                                titleStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white));
                          }).toList(),
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchresponse) {},
                            enabled: true,
                          )),
                    ),
                  )
                : const SizedBox(
                    height: 400,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [TLoaderAnimation()])),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          //Show Status and Color Meta
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => DataTable(
                columns: const [
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Orders')),
                  DataColumn(label: Text('Total')),
                ],
                rows: controller.orderStatusData.entries.map(
                  (entry) {
                    final OrderStatus status = entry.key;
                    final int count = entry.value;
                    final double totalAmount = controller.totalAmounts[status]!;
                    final String diaplayStatus = controller.getDisplayStatusName(status);

                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              TCircularContainer(
                                  width: 20,
                                  height: 20,
                                  backgroundColor:
                                      THelperFunctions.getOrderStatusColor(status)),
                              Expanded(child: Text(' $diaplayStatus'))
                            ],
                          ),
                        ),
                        DataCell(Text(count.toString())),
                        DataCell(Text('₹${totalAmount.toStringAsFixed(2)}')),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
