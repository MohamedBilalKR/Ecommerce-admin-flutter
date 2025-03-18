import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:flutter/material.dart';

import 'responsive_screens/orders_desktop.dart';
import 'responsive_screens/orders_mobile.dart';
import 'responsive_screens/orders_tablet.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: OrdersDesktopScreen(),
      tablet: OrdersTabletScreen(),
      mobile: OrdersMobileScreen(),
    );
  }
}
