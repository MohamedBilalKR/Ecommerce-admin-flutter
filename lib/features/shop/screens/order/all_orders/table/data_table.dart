import 'package:data_table_2/data_table_2.dart';
import 'package:e_commerce_admin/common/widgets/data_table/paginated_data_table.dart';
import 'package:e_commerce_admin/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/order/order_controller.dart';
import 'table_source.dart';

class OrdersTable extends StatelessWidget {
  const OrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    return Obx(
      () {
        Text(controller.filteredItems.length.toString());
        Text(controller.selectedRows.length.toString());

        return TPaginatedDataTable(
          minWidth: 700,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            const DataColumn2(label: Text('Order ID')),
            DataColumn2(
                label: const Text('Date'),
                onSort: (columnIndex, ascending) => controller.sortByDate(columnIndex, ascending)),
            const DataColumn2(label: Text('Items')),
            DataColumn2(
                label: const Text('Status'),
                fixedWidth: TDeviceUtils.isMobileScreen(context) ? 120 : null),
            const DataColumn2(label: Text('Amount')),
            const DataColumn2(label: Text('Action'), fixedWidth: 100),
          ],
          source: OrdersRows(),
        );
      },
    );
  }
}
