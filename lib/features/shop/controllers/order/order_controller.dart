import 'package:e_commerce_admin/data/abstract/base_data_table_controller.dart';
import 'package:e_commerce_admin/data/repositories/order/order_repository.dart';
import 'package:e_commerce_admin/features/shop/models/order_model.dart';
import 'package:e_commerce_admin/utils/constants/enums.dart';
import 'package:e_commerce_admin/utils/popups/loaders.dart';
import 'package:get/get.dart';

class OrderController extends BaseController<OrderModel> {
  static OrderController get instance => Get.find();

  RxBool statusLoader = false.obs;
  var orderStatus = OrderStatus.delivered.obs;
  final _orderRepository = Get.put(OrderRepository());

  @override
  Future<List<OrderModel>> fetchItems() async {
    sortAscending.value = false;
    return await _orderRepository.fetchAllOrders();
  }

  @override
  bool containsSearchQuery(OrderModel item, String query) {
    return item.id.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(OrderModel item) async {
    await _orderRepository.deleteOrder(item.docId);
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
        (OrderModel o) => o.totalAmount.toString().toLowerCase());
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
        (OrderModel o) => o.orderDate.toString().toLowerCase());
  }

  //Update Order Status
  Future<void> updateOrderStatus(OrderModel order, OrderStatus newStatus) async {
  try {
    statusLoader.value = true;
    
    await _orderRepository.updateOrderSpecificValue(order.docId, {'Status': newStatus.toString()});
    
    orderStatus.value = newStatus;
    orderStatus.refresh(); 

    updateItemFromLists(order);
    TLoaders.successSnackBar(title: 'Updated', message: 'Order Status Updated');
  } catch (e) {
    TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
  } finally {
    statusLoader.value = false;
  }
}
}
