import 'package:e_commerce_admin/common/widgets/layouts/template/site_template.dart';
import 'package:flutter/material.dart';

import 'responsive_screens/customers_desktop.dart';
import 'responsive_screens/customers_mobile.dart';
import 'responsive_screens/customers_tablet.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      desktop: CustomersDesktopScreen(),
      tablet: CustomersTabletScreen(),
      mobile: CustomersMobileScreen(),
    );
  }
}
