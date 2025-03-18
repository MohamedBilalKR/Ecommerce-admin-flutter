import 'package:e_commerce_admin/data/abstract/base_data_table_controller.dart';
import 'package:e_commerce_admin/data/repositories/user/user_repository.dart';
import 'package:e_commerce_admin/features/personalization/models/user_model.dart';
import 'package:get/get.dart';

class CustomerController extends BaseController<UserModel>{
  static CustomerController get instance => Get.find();

  final _customerRepository = Get.put(UserRepository());
  
  @override
  Future<List<UserModel>> fetchItems() async {
    return await _customerRepository.getAllUsers();
  }

  @override
  bool containsSearchQuery(UserModel item, String query) {
    return item.fullName.toLowerCase().contains(query.toLowerCase());
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (UserModel o) => o.fullName.toString().toLowerCase());
  }
  
  @override
  Future<void> deleteItem(UserModel item) async {
    await _customerRepository.deleteUser(item.id ?? '');
  }
}