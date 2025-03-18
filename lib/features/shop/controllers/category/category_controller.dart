import 'package:e_commerce_admin/data/abstract/base_data_table_controller.dart';
import 'package:e_commerce_admin/data/repositories/category/category_repository.dart';
import 'package:e_commerce_admin/features/shop/models/category_model.dart';
import 'package:get/get.dart';

class CategoryController extends BaseController<CategoryModel> {
  static CategoryController get instance => Get.find();

  final _categoryRepository = Get.put(CategoryRepository());
  
  @override
  bool containsSearchQuery(CategoryModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }
  
  @override
  Future<void> deleteItem(CategoryModel item) {
    return _categoryRepository.deleteCategory(item.id);
  }
  
  @override
  Future<List<CategoryModel>> fetchItems() async {
    return await _categoryRepository.getAllCategories();
  }

  //Sorting Related Code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CategoryModel category) => category.name.toLowerCase());
  }
}
