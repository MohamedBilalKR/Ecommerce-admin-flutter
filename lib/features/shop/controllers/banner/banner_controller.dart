import 'package:e_commerce_admin/data/abstract/base_data_table_controller.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/banner/banner_repository.dart';
import '../../models/banner_model.dart';

class BannerController extends BaseController<BannerModel> {
  static BannerController get instance => Get.find();

  final _bannerRepository = Get.put(BannerRepository());

  @override
  Future<List<BannerModel>> fetchItems() async {
    return await _bannerRepository.getAllBanners();
  }

  @override
  bool containsSearchQuery(BannerModel item, String query) {
    return false;
  }

  @override
  Future<void> deleteItem(BannerModel item) async {
    await _bannerRepository.deleteBanner(item.id ?? '');
  }
}
