import 'package:e_commerce_admin/data/repositories/user/user_repository.dart';
import 'package:e_commerce_admin/features/personalization/models/user_model.dart';
import 'package:e_commerce_admin/features/shop/models/order_model.dart';
import 'package:e_commerce_admin/utils/popups/loaders.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController{
  static OrderDetailController get instance => Get.find();

  RxBool loading = true.obs;
  Rx<OrderModel> order = OrderModel.empty().obs;
  Rx<UserModel> customer = UserModel.empty().obs;

  //Load Customer Orders
  Future<void> getCustomerOfCurrentOrder() async {
    try {
      loading.value = true;
      final user = await UserRepository.instance.fetchUserDetails(order.value.userId);
      customer.value = user;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      loading.value = false;
    }
  }
}