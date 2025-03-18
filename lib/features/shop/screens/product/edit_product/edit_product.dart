import 'package:e_commerce_admin/features/shop/controllers/product/edit_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/template/site_template.dart';
import 'responsive_screens/edit_product_desktop.dart';
import 'responsive_screens/edit_product_mobile.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProductController());
    final product = Get.arguments;
    controller.initProductData(product);
    
    return SiteTemplate(
      desktop: EditProductDesktopScreen(product: product),
      mobile: EditProductMobileScreen(product: product),
    );
  }
}
