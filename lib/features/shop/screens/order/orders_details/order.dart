import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'responsive_screens/order_details_desktop.dart';
import 'responsive_screens/order_details_mobile.dart';
import 'responsive_screens/order_details_tablet.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments;
    return SiteTemplate(
      desktop: OrderDetailsDesktopScreen(order: order),
      tablet: OrderDetailsTabletScreen(order: order),
      mobile: OrderDetailsMobileScreen(order: order),
    );
  }
}
