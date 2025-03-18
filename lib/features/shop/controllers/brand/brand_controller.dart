import 'package:e_commerce_admin/data/abstract/base_data_table_controller.dart';
import 'package:e_commerce_admin/data/repositories/brand/brand_repository.dart';
import 'package:e_commerce_admin/features/shop/controllers/category/category_controller.dart';
import 'package:e_commerce_admin/features/shop/models/brand_model.dart';
import 'package:get/get.dart';

class BrandController extends BaseController<BrandModel> {
  static BrandController get instance => Get.find();

  final _brandRepository = Get.put(BrandRepository());
  final categoryController = Get.put(CategoryController());

  @override
  Future<List<BrandModel>> fetchItems() async {
    //Fetch Brands
    final fetchedBrands = await _brandRepository.getAllBrands();

    //Fetch Brand Categories Relational data
    final fetchedBrandCategories =
        await _brandRepository.getAllBrandCategories();

    //fetch all Categories is data does not alraedy exists
    if (categoryController.allItems.isNotEmpty) {
      await categoryController.fetchItems();
    }

    //Loop all brands and fetch categories of each
    for (var brand in fetchedBrands) {
      List<String> categoryIds = fetchedBrandCategories
          .where((brandCategory) => brandCategory.brandId == brand.id)
          .map((brandCategory) => brandCategory.categoryId)
          .toList();

      brand.brandCategories = categoryController.allItems
          .where((category) => categoryIds.contains(category.id))
          .toList();
    }
    return fetchedBrands;
  }

  @override
  bool containsSearchQuery(BrandModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(BrandModel item) async {
    await _brandRepository.deleteBrand(item);
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
        (BrandModel brand) => brand.name.toLowerCase());
  }
}
