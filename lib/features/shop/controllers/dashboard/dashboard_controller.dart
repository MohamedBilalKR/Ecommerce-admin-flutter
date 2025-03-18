import 'package:e_commerce_admin/data/abstract/base_data_table_controller.dart';
import 'package:e_commerce_admin/features/shop/controllers/customer/customer_controller.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:e_commerce_admin/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

import '../../models/order_model.dart';
import '../order/order_controller.dart';

class DashboardController extends BaseController<OrderModel> {
  static DashboardController get instance => Get.find();

  final orderController = Get.put(OrderController());
  final customerController = Get.put(CustomerController());

  final RxList<double> weeklySales = <double>[].obs;
  final RxMap<OrderStatus, int> orderStatusData = <OrderStatus, int>{}.obs;
  final RxMap<OrderStatus, double> totalAmounts = <OrderStatus, double>{}.obs;

  @override
  Future<List<OrderModel>> fetchItems() async {
    if (orderController.allItems.isEmpty) {
      await orderController.fetchItems();
    }

    if (customerController.allItems.isEmpty) {
      await customerController.fetchItems();
    }

    _calculateWeeklySales();
    _calculateOrderStatusData();

    return orderController.allItems;

  }

  void _calculateWeeklySales() {
    //reset weeklysales to zero
    weeklySales.value = List<double>.filled(7, 0.0);
    for (var order in orderController.allItems) {
      final DateTime orderWeekStart =
          THelperFunctions.getStartOfWeek(order.orderDate);

      //Check if the order is within the current week
      if (orderWeekStart.isBefore(DateTime.now()) &&
          orderWeekStart.add(const Duration(days: 7)).isAfter(DateTime.now())) {
        int index = (order.orderDate.weekday - 1) % 7;

        //Ensure the index is non-negative
        index = index < 0 ? index + 7 : index;

        weeklySales[index] += order.totalAmount;
      }
    }
  }

  void _calculateOrderStatusData() {
    //Reset status data
    orderStatusData.clear();

    //Map to store the total amount
    totalAmounts.value = {for (var status in OrderStatus.values) status: 0.0};

    for (var order in orderController.allItems) {
      //Count Orders
      final status = order.status;
      orderStatusData[status] = (orderStatusData[status] ?? 0) + 1;

      //Calculate Total Amounts
      totalAmounts[status] = (totalAmounts[status] ?? 0) + order.totalAmount;
    }
  }

  String getDisplayStatusName(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.delivered:
        return 'Delivered';
      default:
        return 'Unknown Status';
    }
  }

  @override
  bool containsSearchQuery(OrderModel item, String query) => false;

  @override
  Future<void> deleteItem(OrderModel item) async {}
}
