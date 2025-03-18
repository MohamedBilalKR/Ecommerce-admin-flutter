import 'package:e_commerce_admin/features/authentication/controllers/user_controller.dart';
import 'package:e_commerce_admin/features/shop/controllers/product/product_images_controller.dart';
import 'package:e_commerce_admin/utils/helpers/network_manager.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';

import '../features/personalization/controllers/profile_controller.dart';
import '../features/personalization/controllers/settings_controller.dart';
import '../features/shop/controllers/brand/brand_controller.dart';
import '../features/shop/controllers/product/product_attributes_controller.dart';
import '../features/shop/controllers/product/product_controller.dart';
import '../features/shop/controllers/product/product_variations_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => ProductImagesController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => ProductAttributesController(), fenix: true);
    Get.lazyPut(() => ProductVariationsController(), fenix: true);
    Get.lazyPut(() => BrandController(), fenix: true);
  }
}
