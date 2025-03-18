import 'package:e_commerce_admin/data/repositories/user/user_repository.dart';
import 'package:e_commerce_admin/features/personalization/models/user_model.dart';
import 'package:e_commerce_admin/features/shop/models/order_model.dart';
import 'package:e_commerce_admin/utils/popups/loaders.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/address/address_repository.dart';

class CustomerDetailsController extends GetxController {
  static CustomerDetailsController get instance => Get.find();

  RxBool ordersLoading = true.obs;
  RxBool addressLoading = true.obs;
  RxBool sortAscending = true.obs;
  RxInt sortColumnIndex = 1.obs;
  RxList<bool> selectedRows = <bool>[].obs;
  Rx<UserModel> customer = UserModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());
  final searchTextController = TextEditingController();
  RxList<OrderModel> allCustomerOrders = <OrderModel>[].obs;
  RxList<OrderModel> filteredCustomerOrders = <OrderModel>[].obs;

  Future<void> getCustomerOrders() async {
    try {
      ordersLoading.value = true;

      if (customer.value.id != null && customer.value.id!.isNotEmpty) {
        customer.value.orders =
            await UserRepository.instance.fetchUserOrders(customer.value.id!);
      }

      allCustomerOrders.assignAll(customer.value.orders ?? []);

      filteredCustomerOrders.assignAll(customer.value.orders ?? []);

      selectedRows.assignAll(List.generate(
          customer.value.orders != null ? customer.value.orders!.length : 0,
          (index) => false));
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    } finally {
      ordersLoading.value = false;
    }
  }

  Future<void> getCustomerAddresses() async {
    try {
      addressLoading.value = true;

      if (customer.value.id != null && customer.value.id!.isNotEmpty) {
        customer.value.addresses = await addressRepository.fetchUserAddresses(customer.value.id!);
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    } finally {
      addressLoading.value = false;
    }
  }

  void searchQuery(String query) {
    filteredCustomerOrders.assignAll(
      allCustomerOrders.where((customer) =>
          customer.id.toLowerCase().contains(query.toLowerCase()) ||
          customer.orderDate.toString().contains(query.toLowerCase())),
    );

    update();
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortAscending.value = ascending;
    filteredCustomerOrders.sort(
      (a, b) {
        if (ascending) {
          return a.id.toLowerCase().compareTo(b.id.toLowerCase());
        } else {
          return b.id.toLowerCase().compareTo(a.id.toLowerCase());
        }
      },
    );
    this.sortColumnIndex.value = sortColumnIndex;
    update();
  }
}
